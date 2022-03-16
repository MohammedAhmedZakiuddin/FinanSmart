const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.onCreateTransaction = functions.firestore
    .document("/Transactions/{userId}/Transactions/{transactionId}")
    .onCreate(async (snapshot, context) => {
        console.log("Transaction Created", snapshot.id);
        const userId = context.params.userId;
        const transactionId = context.params.transactionId;

        const userRef = admin.firestore()
            .collection("Users")
            .doc(userId);

        const transactionRef = admin.firestore()
            .collection("Transactions")
            .doc(userId)
            .collection("Transactions")
            .doc(transactionId);

        const transactionDocSnapshot = await transactionRef.get();
        const userDocSnapshot = await userRef.get();

        let transaction = transactionDocSnapshot.data();
        let user = userDocSnapshot.data();

        if (transaction.transactionType == "expense") {
            userRef.update({
                balance: user.balance - transaction.amount,
            });
        } else {
            userRef.update({
                balance: user.balance + transaction.amount,
            });
        }

        admin.firestore().collection("Notifications").doc(userId)
            .collection("Notifications").doc().set({
                title: "Transaction Created",
                content: "Transaction Type: " + transaction.transactionType + "\n" +
                    "Amount: $" + transaction.amount + "\n"
            });

    });

exports.onUpdateTransaction = functions.firestore
    .document("/Transactions/{userId}/Transactions/{transactionId}")
    .onUpdate(async (change, context) => {
        const userId = context.params.userId;

        const transactionId = context.params.transactionId;
        console.log("Transaction Update", transactionId);

        const transactionBefore = change.before.data();
        const transactionAfter = change.after.data();

        const userRef = admin.firestore()
            .collection("Users")
            .doc(userId);


        const userDocSnapshot = await userRef.get();

        let user = userDocSnapshot.data();


        if (transactionBefore.amount != transactionAfter.amount &&
            transactionAfter.transactionType == "expense" &&
            transactionBefore.transactionType == "expense") {
            userRef.update({
                balance: user.balance + transactionBefore.amount - transactionAfter.amount,
            });
        } else if (transactionBefore.amount != transactionAfter.amount &&
            transactionAfter.transactionType == "income" &&
            transactionBefore.transactionType == "income") {
            userRef.update({
                balance: user.balance - transactionBefore.amount + transactionAfter.amount,
            });
        }
        else if (transactionBefore.amount != transactionAfter.amount &&
            transactionAfter.transactionType == "income" &&
            transactionBefore.transactionType == "expense") {
            userRef.update({
                balance: user.balance + transactionBefore.amount + transactionAfter.amount,
            });
        }
        else if (transactionBefore.amount != transactionAfter.amount &&
            transactionAfter.transactionType == "expense" &&
            transactionBefore.transactionType == "income") {
            userRef.update({
                balance: user.balance - transactionBefore.amount - transactionAfter.amount,
            });
        }
        else if (transactionBefore.amount == transactionAfter.amount &&
            transactionAfter.transactionType == "income" &&
            transactionBefore.transactionType == "expense") {
            userRef.update({
                balance: user.balance + transactionBefore.amount + transactionAfter.amount,
            });
        } else if (transactionBefore.amount == transactionAfter.amount &&
            transactionAfter.transactionType == "expense" &&
            transactionBefore.transactionType == "income") {
            userRef.update({
                balance: user.balance - transactionBefore.amount - transactionAfter.amount,
            });
        }

        admin.firestore().collection("Notifications").doc(userId)
            .collection("Notifications").doc().set({
                title: "Transaction Updated",
                content: "Transaction Type: " + transactionAfter.transactionType + "\n" +
                    "Amount: $" + transactionAfter.amount + "\n"
            });

    });

exports.onDeleteTransaction = functions.firestore
    .document("/Transactions/{userId}/Transactions/{transactionId}")
    .onUpdate(async (snapshot, context) => {
        console.log("Transaction Deleted", snapshot.id);
        const userId = context.params.userId;
        const transactionId = context.params.transactionId;

        const userRef = admin.firestore()
            .collection("Users")
            .doc(userId);

        const transactionRef = admin.firestore()
            .collection("Transactions")
            .doc(userId)
            .collection("Transactions")
            .doc(transactionId);

        const transactionDocSnapshot = await transactionRef.get();
        const userDocSnapshot = await userRef.get();

        let transaction = transactionDocSnapshot.data();
        let user = userDocSnapshot.data();

        if (transaction.transactionType == "expense") {
            userRef.update({
                balance: user.balance + transaction.amount,
            });
        } else {
            userRef.update({
                balance: user.balance - transaction.amount,
            });
        }

    });

exports.onUserUpdate = functions.firestore
    .document("/Users/{userId}")
    .onUpdate(async (change, context) => {
        const userId = context.params.userId;
        console.log("Balance Update", userId);
        const userAfter = change.after.data();
        const userRef = await admin.firestore()
            .collection("Users")
            .doc(userId).get();

        const androidNotificationToken = userRef.data().androidNotificationToken;

        const message = {
            notification: {
                title: "Low Balance",
                body: "Your balance is below $200",
            },
            token: androidNotificationToken,
            data: {
                title: "Low Balance",
                body: "Your balance is below $200",
            }
        };

        if (userAfter.balance < 200.00) {
            admin.messaging().send(message)
                .then((response) => {
                    console.log(message)
                    admin.firestore().collection("Notifications").doc(userId)
                        .collection("Notifications").doc().set({
                            title: "Low Balance",
                            content: "Your balance is below $200",
                        });


                    console.log('Successfully sent message:', response);
                })
                .catch((error) => {
                    console.log('Error sending message:', error);
                })
        }

    });


exports.onCreateTarget = functions.firestore
    .document("/Save/{saveId}")
    .onCreate(async (snapshot, context) => {
        console.log("Saving Target Created", snapshot.id);
        const saveId = context.params.saveId
        const userId = context.params.saveId


        const saveRef = admin.firestore()
            .collection("Users")
            .doc(saveId);

        const userRef = admin.firestore()
            .collection("Users")
            .doc(userId);

        const saveDocSnapshot = await saveRef.get();
        const userDocSnapshot = await userRef.get();

        let save = saveDocSnapshot.data();
        let user = userDocSnapshot.data();

        const androidNotificationToken = user.androidNotificationToken;

        const message = {
            notification: {
                title: "Target Created",
                body: "Target amount: $" + save.amount,
            },
            token: androidNotificationToken,
            data: {
                title: "Target Created",
                body: "Target amount: $" + save.amount,
                expiredAt: save.expiredAt,
            }
        };

        admin.messaging().send(message)
            .then((response) => {
                console.log(message)
                admin.firestore().collection("Notifications").doc(userId)
                    .collection("Notifications").doc().set({
                        title: save.title,
                        content: save.description + "\n" +
                            "Amount: $" + save.amount + "\n" +
                            "Target Date: " + save.expiredAt
                    })
                console.log('Successfully sent message:', response);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            })



    });

exports.onUpdatearget = functions.firestore
    .document("/Save/{saveId}")
    .onUpdate(async (change, context) => {
        const saveId = context.params.saveId
        const userId = context.params.saveId
        console.log("Saving Target Updated", saveId);

        const saveBefore = change.before.data();
        const saveAfter = change.after.data();

        const saveRef = admin.firestore()
            .collection("Users")
            .doc(saveId);

        const userRef = admin.firestore()
            .collection("Users")
            .doc(userId);

        const saveDocSnapshot = await saveRef.get();
        const userDocSnapshot = await userRef.get();

        let save = saveDocSnapshot.data();
        let user = userDocSnapshot.data();

        const androidNotificationToken = user.androidNotificationToken;

        const message = {
            notification: {
                title: "Target Updated",
                body: "Target amount: $" + saveAfter.amount,
            },
            token: androidNotificationToken,
            data: {
                title: "Target Updated",
                body: "Target amount: $" + saveAfter.amount,
                expiredAt: saveAfter.expiredAt,
            }
        };

        admin.messaging().send(message)
            .then((response) => {
                console.log(message)
                admin.firestore().collection("Notifications").doc(userId)
                    .collection("Notifications").doc().set({
                        title: saveAfter.title,
                        content: saveAfter.description + "\n" +
                            "Amount: $" + saveAfter.amount + "\n" +
                            "Target Date: " + saveAfter.expiredAt
                    })

                console.log('Successfully sent message:', response);
            })
            .catch((error) => {
                console.log('Error sending message:', error);
            })
    });