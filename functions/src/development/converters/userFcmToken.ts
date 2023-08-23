import { FirestoreDataConverter } from '@google-cloud/firestore'
import { UserFcmToken } from '../models/userFcmToken'

export const userFcmTokenConverter: FirestoreDataConverter<UserFcmToken> = {
    fromFirestore(qds: FirebaseFirestore.QueryDocumentSnapshot): UserFcmToken {
        const data = qds.data()
        return {
            userId: data.userId,
            token: data.token,
            deviceInfo: data.deviceInfo,
            createdAt: data.createdAt,
            updatedAt: data.updatedAt,
        }
    },
    toFirestore(userFcmToken: UserFcmToken): FirebaseFirestore.DocumentData {
        return {
            userId: userFcmToken.userId,
            token: userFcmToken.token,
            deviceInfo: userFcmToken.deviceInfo,
            createdAt: userFcmToken.createdAt,
            updatedAt: userFcmToken.updatedAt,
        }
    }
}
