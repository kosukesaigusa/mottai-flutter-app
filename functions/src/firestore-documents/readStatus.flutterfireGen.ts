import * as admin from 'firebase-admin'
import {
    CollectionReference,
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

export class ReadReadStatus {
    constructor({
        readStatusId,
        path,
        lastReadAt
    }: {
        readStatusId: string
        path: string
        lastReadAt?: Date
    }) {
        this.readStatusId = readStatusId
        this.path = path
        this.lastReadAt = lastReadAt
    }

    readonly readStatusId: string

    readonly path: string

    readonly lastReadAt?: Date

    private static fromJson(json: Record<string, unknown>): ReadReadStatus {
        return new ReadReadStatus({
            readStatusId: json[`readStatusId`] as string,
            path: json[`path`] as string,
            lastReadAt: (json[`lastReadAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadReadStatus {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadReadStatus.fromJson({
            ...cleanedData,
            readStatusId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateReadStatus {
    constructor() {}

    toJson(): Record<string, unknown> {
        return {
            lastReadAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateReadStatus {
    constructor() {}

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        json[`lastReadAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteReadStatus {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the readStatuses collection for reading.
 */
export const readReadStatusCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<ReadReadStatus> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`readStatuses`)
        .withConverter<ReadReadStatus>({
            fromFirestore: (ds: DocumentSnapshot): ReadReadStatus => {
                return ReadReadStatus.fromDocumentSnapshot(ds)
            },
            toFirestore: () => {
                throw new Error(
                    `toFirestore is not implemented for ReadReadStatus`
                )
            }
        })
}

/**
 * Provides a reference to a readStatus document for reading.
 * @param readStatusId - The ID of the readStatus document to read.
 */
export const readReadStatusDocumentReference = ({
    chatRoomId,
    readStatusId
}: {
    chatRoomId: string
    readStatusId: string
}): DocumentReference<ReadReadStatus> =>
    readReadStatusCollectionReference({
        chatRoomId
    }).doc(readStatusId)

/**
 * Provides a reference to the readStatuses collection for creating.
 */
export const createReadStatusCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<CreateReadStatus> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`readStatuses`)
        .withConverter<CreateReadStatus>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for CreateReadStatus`
                )
            },
            toFirestore: (obj: CreateReadStatus): DocumentData => {
                return obj.toJson()
            }
        })
}

/**
 * Provides a reference to a readStatus document for creating.
 * @param readStatusId - The ID of the readStatus document to read.
 */
export const createReadStatusDocumentReference = ({
    chatRoomId,
    readStatusId
}: {
    chatRoomId: string
    readStatusId: string
}): DocumentReference<CreateReadStatus> =>
    createReadStatusCollectionReference({
        chatRoomId
    }).doc(readStatusId)

/**
 * Provides a reference to the readStatuses collection for updating.
 */
export const updateReadStatusCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<UpdateReadStatus> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`readStatuses`)
        .withConverter<UpdateReadStatus>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for UpdateReadStatus`
                )
            },
            toFirestore: (obj: UpdateReadStatus): DocumentData => {
                return obj.toJson()
            }
        })
}

/**
 * Provides a reference to a readStatus document for updating.
 * @param readStatusId - The ID of the readStatus document to read.
 */
export const updateReadStatusDocumentReference = ({
    chatRoomId,
    readStatusId
}: {
    chatRoomId: string
    readStatusId: string
}): DocumentReference<UpdateReadStatus> =>
    updateReadStatusCollectionReference({
        chatRoomId
    }).doc(readStatusId)

/**
 * Provides a reference to the readStatuses collection for deleting.
 */
export const deleteReadStatusCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<DeleteReadStatus> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`readStatuses`)
        .withConverter<DeleteReadStatus>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for DeleteReadStatus`
                )
            },
            toFirestore: (): DocumentData => {
                throw new Error(
                    `toFirestore is not implemented for DeleteReadStatus`
                )
            }
        })
}

/**
 * Provides a reference to a readStatus document for deleting.
 * @param readStatusId - The ID of the readStatus document to read.
 */
export const deleteReadStatusDocumentReference = ({
    chatRoomId,
    readStatusId
}: {
    chatRoomId: string
    readStatusId: string
}): DocumentReference<DeleteReadStatus> =>
    deleteReadStatusCollectionReference({
        chatRoomId
    }).doc(readStatusId)

/**
 * Manages queries against the readStatuses collection.
 */
export class ReadStatusQuery {
    /**
     * Fetches readStatus documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        chatRoomId,
        queryBuilder,
        compare
    }: {
        chatRoomId: string
        queryBuilder?: (query: Query<ReadReadStatus>) => Query<ReadReadStatus>
        compare?: (lhs: ReadReadStatus, rhs: ReadReadStatus) => number
    }): Promise<ReadReadStatus[]> {
        let query: Query<ReadReadStatus> = readReadStatusCollectionReference({
            chatRoomId
        })
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadReadStatus> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadReadStatus>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific readStatus document.
     * @param readStatusId - The ID of the readStatus document to fetch.
     */
    async fetchDocument({
        chatRoomId,
        readStatusId
    }: {
        chatRoomId: string
        readStatusId: string
    }): Promise<ReadReadStatus | undefined> {
        const ds = await readReadStatusDocumentReference({
            chatRoomId,
            readStatusId
        }).get()
        return ds.data()
    }

    /**
     * Adds a readStatus document.
     * @param createReadStatus - The readStatus details to add.
     */
    async add({
        chatRoomId,
        createReadStatus
    }: {
        chatRoomId: string
        createReadStatus: CreateReadStatus
    }): Promise<DocumentReference<CreateReadStatus>> {
        return createReadStatusCollectionReference({ chatRoomId }).add(
            createReadStatus
        )
    }

    /**
     * Sets a readStatus document.
     * @param readStatusId - The ID of the readStatus document to set.
     * @param createReadStatus - The readStatus details to set.
     * @param options - Options for the set operation.
     */
    async set({
        chatRoomId,
        readStatusId,
        createReadStatus,
        options
    }: {
        chatRoomId: string
        readStatusId: string
        createReadStatus: CreateReadStatus
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createReadStatusDocumentReference({
                chatRoomId,
                readStatusId
            }).set(createReadStatus)
        } else {
            return createReadStatusDocumentReference({
                chatRoomId,
                readStatusId
            }).set(createReadStatus, options)
        }
    }

    /**
     * Updates a specific readStatus document.
     * @param readStatusId - The ID of the readStatus document to update.
     * @param updateReadStatus - The details for updating the readStatus.
     */
    async update({
        chatRoomId,
        readStatusId,
        updateReadStatus
    }: {
        chatRoomId: string
        readStatusId: string
        updateReadStatus: UpdateReadStatus
    }): Promise<WriteResult> {
        return updateReadStatusDocumentReference({
            chatRoomId,
            readStatusId
        }).update(updateReadStatus.toJson())
    }

    /**
     * Deletes a specific readStatus document.
     * @param readStatusId - The ID of the readStatus document to delete.
     */
    async delete({
        chatRoomId,
        readStatusId
    }: {
        chatRoomId: string
        readStatusId: string
    }): Promise<WriteResult> {
        return deleteReadStatusDocumentReference({
            chatRoomId,
            readStatusId
        }).delete()
    }
}
