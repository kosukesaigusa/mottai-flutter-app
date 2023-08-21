import * as admin from 'firebase-admin'
import {
    DocumentData,
    DocumentReference,
    DocumentSnapshot,
    Query,
    QueryDocumentSnapshot,
    QuerySnapshot,
    SetOptions,
    WriteResult
} from 'firebase-admin/firestore'

export class ReadUserSocialLogin {
    constructor({
        userSocialLoginId,
        path,
        isGoogleEnabled,
        isAppleEnabled,
        isLINEEnabled
    }: {
        userSocialLoginId: string
        path: string
        isGoogleEnabled: boolean
        isAppleEnabled: boolean
        isLINEEnabled: boolean
    }) {
        this.userSocialLoginId = userSocialLoginId
        this.path = path
        this.isGoogleEnabled = isGoogleEnabled
        this.isAppleEnabled = isAppleEnabled
        this.isLINEEnabled = isLINEEnabled
    }

    readonly userSocialLoginId: string

    readonly path: string

    readonly isGoogleEnabled: boolean

    readonly isAppleEnabled: boolean

    readonly isLINEEnabled: boolean

    private static fromJson(
        json: Record<string, unknown>
    ): ReadUserSocialLogin {
        return new ReadUserSocialLogin({
            userSocialLoginId: json[`userSocialLoginId`] as string,
            path: json[`path`] as string,
            isGoogleEnabled:
                (json[`isGoogleEnabled`] as boolean | undefined) ?? false,
            isAppleEnabled:
                (json[`isAppleEnabled`] as boolean | undefined) ?? false,
            isLINEEnabled:
                (json[`isLINEEnabled`] as boolean | undefined) ?? false
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadUserSocialLogin {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadUserSocialLogin.fromJson({
            ...cleanedData,
            userSocialLoginId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateUserSocialLogin {
    constructor({
        isGoogleEnabled,
        isAppleEnabled,
        isLINEEnabled
    }: {
        isGoogleEnabled: boolean
        isAppleEnabled: boolean
        isLINEEnabled: boolean
    }) {
        this.isGoogleEnabled = isGoogleEnabled
        this.isAppleEnabled = isAppleEnabled
        this.isLINEEnabled = isLINEEnabled
    }

    readonly isGoogleEnabled: boolean

    readonly isAppleEnabled: boolean

    readonly isLINEEnabled: boolean

    toJson(): Record<string, unknown> {
        return {
            isGoogleEnabled: this.isGoogleEnabled,
            isAppleEnabled: this.isAppleEnabled,
            isLINEEnabled: this.isLINEEnabled
        }
    }
}

export class UpdateUserSocialLogin {
    constructor({
        isGoogleEnabled,
        isAppleEnabled,
        isLINEEnabled
    }: {
        isGoogleEnabled?: boolean
        isAppleEnabled?: boolean
        isLINEEnabled?: boolean
    }) {
        this.isGoogleEnabled = isGoogleEnabled
        this.isAppleEnabled = isAppleEnabled
        this.isLINEEnabled = isLINEEnabled
    }

    readonly isGoogleEnabled?: boolean

    readonly isAppleEnabled?: boolean

    readonly isLINEEnabled?: boolean

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.isGoogleEnabled != undefined) {
            json[`isGoogleEnabled`] = this.isGoogleEnabled
        }
        if (this.isAppleEnabled != undefined) {
            json[`isAppleEnabled`] = this.isAppleEnabled
        }
        if (this.isLINEEnabled != undefined) {
            json[`isLINEEnabled`] = this.isLINEEnabled
        }

        return json
    }
}

export class DeleteUserSocialLogin {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the userSocialLogins collection for reading.
 */
export const readUserSocialLoginCollectionReference = db
    .collection(`userSocialLogins`)
    .withConverter<ReadUserSocialLogin>({
        fromFirestore: (ds: DocumentSnapshot): ReadUserSocialLogin => {
            return ReadUserSocialLogin.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(
                `toFirestore is not implemented for ReadUserSocialLogin`
            )
        }
    })

/**
 * Provides a reference to a userSocialLogin document for reading.
 * @param userSocialLoginId - The ID of the userSocialLogin document to read.
 */
export const readUserSocialLoginDocumentReference = ({
    userSocialLoginId
}: {
    userSocialLoginId: string
}): DocumentReference<ReadUserSocialLogin> =>
    readUserSocialLoginCollectionReference.doc(userSocialLoginId)

/**
 * Provides a reference to the userSocialLogins collection for creating.
 */
export const createUserSocialLoginCollectionReference = db
    .collection(`userSocialLogins`)
    .withConverter<CreateUserSocialLogin>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateUserSocialLogin`
            )
        },
        toFirestore: (obj: CreateUserSocialLogin): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a userSocialLogin document for creating.
 * @param userSocialLoginId - The ID of the userSocialLogin document to read.
 */
export const createUserSocialLoginDocumentReference = ({
    userSocialLoginId
}: {
    userSocialLoginId: string
}): DocumentReference<CreateUserSocialLogin> =>
    createUserSocialLoginCollectionReference.doc(userSocialLoginId)

/**
 * Provides a reference to the userSocialLogins collection for updating.
 */
export const updateUserSocialLoginCollectionReference = db
    .collection(`userSocialLogins`)
    .withConverter<UpdateUserSocialLogin>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateUserSocialLogin`
            )
        },
        toFirestore: (obj: UpdateUserSocialLogin): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a userSocialLogin document for updating.
 * @param userSocialLoginId - The ID of the userSocialLogin document to read.
 */
export const updateUserSocialLoginDocumentReference = ({
    userSocialLoginId
}: {
    userSocialLoginId: string
}): DocumentReference<UpdateUserSocialLogin> =>
    updateUserSocialLoginCollectionReference.doc(userSocialLoginId)

/**
 * Provides a reference to the userSocialLogins collection for deleting.
 */
export const deleteUserSocialLoginCollectionReference = db
    .collection(`userSocialLogins`)
    .withConverter<DeleteUserSocialLogin>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteUserSocialLogin`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteUserSocialLogin`
            )
        }
    })

/**
 * Provides a reference to a userSocialLogin document for deleting.
 * @param userSocialLoginId - The ID of the userSocialLogin document to read.
 */
export const deleteUserSocialLoginDocumentReference = ({
    userSocialLoginId
}: {
    userSocialLoginId: string
}): DocumentReference<DeleteUserSocialLogin> =>
    deleteUserSocialLoginCollectionReference.doc(userSocialLoginId)

/**
 * Manages queries against the userSocialLogins collection.
 */
export class UserSocialLoginQuery {
    /**
     * Fetches userSocialLogin documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: Query<ReadUserSocialLogin>
        ) => Query<ReadUserSocialLogin>
        compare?: (lhs: ReadUserSocialLogin, rhs: ReadUserSocialLogin) => number
    }): Promise<ReadUserSocialLogin[]> {
        let query: Query<ReadUserSocialLogin> =
            readUserSocialLoginCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadUserSocialLogin> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadUserSocialLogin>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific userSocialLogin document.
     * @param userSocialLoginId - The ID of the userSocialLogin document to fetch.
     */
    async fetchDocument({
        userSocialLoginId
    }: {
        userSocialLoginId: string
    }): Promise<ReadUserSocialLogin | undefined> {
        const ds = await readUserSocialLoginDocumentReference({
            userSocialLoginId
        }).get()
        return ds.data()
    }

    /**
     * Adds a userSocialLogin document.
     * @param createUserSocialLogin - The userSocialLogin details to add.
     */
    async add({
        createUserSocialLogin
    }: {
        createUserSocialLogin: CreateUserSocialLogin
    }): Promise<DocumentReference<CreateUserSocialLogin>> {
        return createUserSocialLoginCollectionReference.add(
            createUserSocialLogin
        )
    }

    /**
     * Sets a userSocialLogin document.
     * @param userSocialLoginId - The ID of the userSocialLogin document to set.
     * @param createUserSocialLogin - The userSocialLogin details to set.
     * @param options - Options for the set operation.
     */
    async set({
        userSocialLoginId,
        createUserSocialLogin,
        options
    }: {
        userSocialLoginId: string
        createUserSocialLogin: CreateUserSocialLogin
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createUserSocialLoginDocumentReference({
                userSocialLoginId
            }).set(createUserSocialLogin)
        } else {
            return createUserSocialLoginDocumentReference({
                userSocialLoginId
            }).set(createUserSocialLogin, options)
        }
    }

    /**
     * Updates a specific userSocialLogin document.
     * @param userSocialLoginId - The ID of the userSocialLogin document to update.
     * @param updateUserSocialLogin - The details for updating the userSocialLogin.
     */
    async update({
        userSocialLoginId,
        updateUserSocialLogin
    }: {
        userSocialLoginId: string
        updateUserSocialLogin: UpdateUserSocialLogin
    }): Promise<WriteResult> {
        return updateUserSocialLoginDocumentReference({
            userSocialLoginId
        }).update(updateUserSocialLogin.toJson())
    }

    /**
     * Deletes a specific userSocialLogin document.
     * @param userSocialLoginId - The ID of the userSocialLogin document to delete.
     */
    async delete({
        userSocialLoginId
    }: {
        userSocialLoginId: string
    }): Promise<WriteResult> {
        return deleteUserSocialLoginDocumentReference({
            userSocialLoginId
        }).delete()
    }
}
