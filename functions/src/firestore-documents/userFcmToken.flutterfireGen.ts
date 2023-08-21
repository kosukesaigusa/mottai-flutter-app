import * as admin from 'firebase-admin'
import {
    DocumentData,
    DocumentReference,
    DocumentSnapshot,
    FieldValue,
    Query,
    QueryDocumentSnapshot,
    QuerySnapshot,
    SetOptions,
    Timestamp,
    WriteResult
} from 'firebase-admin/firestore'

export class ReadUserFcmToken {
    constructor({
        userFcmTokenId,
        path,
        userId,
        token,
        deviceInfo,
        createdAt,
        updatedAt
    }: {
        userFcmTokenId: string
        path: string
        userId: string
        token: string
        deviceInfo: string
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.userFcmTokenId = userFcmTokenId
        this.path = path
        this.userId = userId
        this.token = token
        this.deviceInfo = deviceInfo
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly userFcmTokenId: string

    readonly path: string

    readonly userId: string

    readonly token: string

    readonly deviceInfo: string

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static fromJson(json: Record<string, unknown>): ReadUserFcmToken {
        return new ReadUserFcmToken({
            userFcmTokenId: json[`userFcmTokenId`] as string,
            path: json[`path`] as string,
            userId: json[`userId`] as string,
            token: json[`token`] as string,
            deviceInfo: (json[`deviceInfo`] as string | undefined) ?? ``,
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadUserFcmToken {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadUserFcmToken.fromJson({
            ...cleanedData,
            userFcmTokenId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateUserFcmToken {
    constructor({
        userId,
        token,
        deviceInfo
    }: {
        userId: string
        token: string
        deviceInfo: string
    }) {
        this.userId = userId
        this.token = token
        this.deviceInfo = deviceInfo
    }

    readonly userId: string

    readonly token: string

    readonly deviceInfo: string

    toJson(): Record<string, unknown> {
        return {
            userId: this.userId,
            token: this.token,
            deviceInfo: this.deviceInfo,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateUserFcmToken {
    constructor({
        userId,
        token,
        deviceInfo,
        createdAt
    }: {
        userId?: string
        token?: string
        deviceInfo?: string
        createdAt?: Date
    }) {
        this.userId = userId
        this.token = token
        this.deviceInfo = deviceInfo
        this.createdAt = createdAt
    }

    readonly userId?: string

    readonly token?: string

    readonly deviceInfo?: string

    readonly createdAt?: Date

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.userId != undefined) {
            json[`userId`] = this.userId
        }
        if (this.token != undefined) {
            json[`token`] = this.token
        }
        if (this.deviceInfo != undefined) {
            json[`deviceInfo`] = this.deviceInfo
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteUserFcmToken {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the userFcmTokens collection for reading.
 */
export const readUserFcmTokenCollectionReference = db
    .collection(`userFcmTokens`)
    .withConverter<ReadUserFcmToken>({
        fromFirestore: (ds: DocumentSnapshot): ReadUserFcmToken => {
            return ReadUserFcmToken.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(
                `toFirestore is not implemented for ReadUserFcmToken`
            )
        }
    })

/**
 * Provides a reference to a userFcmToken document for reading.
 * @param userFcmTokenId - The ID of the userFcmToken document to read.
 */
export const readUserFcmTokenDocumentReference = ({
    userFcmTokenId
}: {
    userFcmTokenId: string
}): DocumentReference<ReadUserFcmToken> =>
    readUserFcmTokenCollectionReference.doc(userFcmTokenId)

/**
 * Provides a reference to the userFcmTokens collection for creating.
 */
export const createUserFcmTokenCollectionReference = db
    .collection(`userFcmTokens`)
    .withConverter<CreateUserFcmToken>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateUserFcmToken`
            )
        },
        toFirestore: (obj: CreateUserFcmToken): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a userFcmToken document for creating.
 * @param userFcmTokenId - The ID of the userFcmToken document to read.
 */
export const createUserFcmTokenDocumentReference = ({
    userFcmTokenId
}: {
    userFcmTokenId: string
}): DocumentReference<CreateUserFcmToken> =>
    createUserFcmTokenCollectionReference.doc(userFcmTokenId)

/**
 * Provides a reference to the userFcmTokens collection for updating.
 */
export const updateUserFcmTokenCollectionReference = db
    .collection(`userFcmTokens`)
    .withConverter<UpdateUserFcmToken>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateUserFcmToken`
            )
        },
        toFirestore: (obj: UpdateUserFcmToken): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a userFcmToken document for updating.
 * @param userFcmTokenId - The ID of the userFcmToken document to read.
 */
export const updateUserFcmTokenDocumentReference = ({
    userFcmTokenId
}: {
    userFcmTokenId: string
}): DocumentReference<UpdateUserFcmToken> =>
    updateUserFcmTokenCollectionReference.doc(userFcmTokenId)

/**
 * Provides a reference to the userFcmTokens collection for deleting.
 */
export const deleteUserFcmTokenCollectionReference = db
    .collection(`userFcmTokens`)
    .withConverter<DeleteUserFcmToken>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteUserFcmToken`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteUserFcmToken`
            )
        }
    })

/**
 * Provides a reference to a userFcmToken document for deleting.
 * @param userFcmTokenId - The ID of the userFcmToken document to read.
 */
export const deleteUserFcmTokenDocumentReference = ({
    userFcmTokenId
}: {
    userFcmTokenId: string
}): DocumentReference<DeleteUserFcmToken> =>
    deleteUserFcmTokenCollectionReference.doc(userFcmTokenId)

/**
 * Manages queries against the userFcmTokens collection.
 */
export class UserFcmTokenQuery {
    /**
     * Fetches userFcmToken documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: Query<ReadUserFcmToken>
        ) => Query<ReadUserFcmToken>
        compare?: (lhs: ReadUserFcmToken, rhs: ReadUserFcmToken) => number
    }): Promise<ReadUserFcmToken[]> {
        let query: Query<ReadUserFcmToken> = readUserFcmTokenCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadUserFcmToken> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadUserFcmToken>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific userFcmToken document.
     * @param userFcmTokenId - The ID of the userFcmToken document to fetch.
     */
    async fetchDocument({
        userFcmTokenId
    }: {
        userFcmTokenId: string
    }): Promise<ReadUserFcmToken | undefined> {
        const ds = await readUserFcmTokenDocumentReference({
            userFcmTokenId
        }).get()
        return ds.data()
    }

    /**
     * Adds a userFcmToken document.
     * @param createUserFcmToken - The userFcmToken details to add.
     */
    async add({
        createUserFcmToken
    }: {
        createUserFcmToken: CreateUserFcmToken
    }): Promise<DocumentReference<CreateUserFcmToken>> {
        return createUserFcmTokenCollectionReference.add(createUserFcmToken)
    }

    /**
     * Sets a userFcmToken document.
     * @param userFcmTokenId - The ID of the userFcmToken document to set.
     * @param createUserFcmToken - The userFcmToken details to set.
     * @param options - Options for the set operation.
     */
    async set({
        userFcmTokenId,
        createUserFcmToken,
        options
    }: {
        userFcmTokenId: string
        createUserFcmToken: CreateUserFcmToken
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createUserFcmTokenDocumentReference({
                userFcmTokenId
            }).set(createUserFcmToken)
        } else {
            return createUserFcmTokenDocumentReference({
                userFcmTokenId
            }).set(createUserFcmToken, options)
        }
    }

    /**
     * Updates a specific userFcmToken document.
     * @param userFcmTokenId - The ID of the userFcmToken document to update.
     * @param updateUserFcmToken - The details for updating the userFcmToken.
     */
    async update({
        userFcmTokenId,
        updateUserFcmToken
    }: {
        userFcmTokenId: string
        updateUserFcmToken: UpdateUserFcmToken
    }): Promise<WriteResult> {
        return updateUserFcmTokenDocumentReference({
            userFcmTokenId
        }).update(updateUserFcmToken.toJson())
    }

    /**
     * Deletes a specific userFcmToken document.
     * @param userFcmTokenId - The ID of the userFcmToken document to delete.
     */
    async delete({
        userFcmTokenId
    }: {
        userFcmTokenId: string
    }): Promise<WriteResult> {
        return deleteUserFcmTokenDocumentReference({
            userFcmTokenId
        }).delete()
    }
}
