export class UserFcmToken {
    userId = ``;
    token = ``;
    deviceInfo = ``;
    createdAt?: FirebaseFirestore.Timestamp
    updatedAt?: FirebaseFirestore.Timestamp

    constructor(partial?: Partial<UserFcmToken>) {
        Object.assign(this, partial)
    }
}
