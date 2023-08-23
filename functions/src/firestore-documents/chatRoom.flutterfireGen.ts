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

export class ReadChatRoom {
    constructor({
        chatRoomId,
        path,
        workerId,
        hostId,
        createdAt,
        updatedAt
    }: {
        chatRoomId: string
        path: string
        workerId: string
        hostId: string
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.chatRoomId = chatRoomId
        this.path = path
        this.workerId = workerId
        this.hostId = hostId
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly chatRoomId: string

    readonly path: string

    readonly workerId: string

    readonly hostId: string

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static fromJson(json: Record<string, unknown>): ReadChatRoom {
        return new ReadChatRoom({
            chatRoomId: json[`chatRoomId`] as string,
            path: json[`path`] as string,
            workerId: json[`workerId`] as string,
            hostId: json[`hostId`] as string,
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadChatRoom {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadChatRoom.fromJson({
            ...cleanedData,
            chatRoomId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateChatRoom {
    constructor({ workerId, hostId }: { workerId: string; hostId: string }) {
        this.workerId = workerId
        this.hostId = hostId
    }

    readonly workerId: string

    readonly hostId: string

    toJson(): Record<string, unknown> {
        return {
            workerId: this.workerId,
            hostId: this.hostId,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateChatRoom {
    constructor({
        workerId,
        hostId,
        createdAt
    }: {
        workerId?: string
        hostId?: string
        createdAt?: Date
    }) {
        this.workerId = workerId
        this.hostId = hostId
        this.createdAt = createdAt
    }

    readonly workerId?: string

    readonly hostId?: string

    readonly createdAt?: Date

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.workerId != undefined) {
            json[`workerId`] = this.workerId
        }
        if (this.hostId != undefined) {
            json[`hostId`] = this.hostId
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteChatRoom {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the chatRooms collection for reading.
 */
export const readChatRoomCollectionReference = db
    .collection(`chatRooms`)
    .withConverter<ReadChatRoom>({
        fromFirestore: (ds: DocumentSnapshot): ReadChatRoom => {
            return ReadChatRoom.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(`toFirestore is not implemented for ReadChatRoom`)
        }
    })

/**
 * Provides a reference to a chatRoom document for reading.
 * @param chatRoomId - The ID of the chatRoom document to read.
 */
export const readChatRoomDocumentReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): DocumentReference<ReadChatRoom> =>
    readChatRoomCollectionReference.doc(chatRoomId)

/**
 * Provides a reference to the chatRooms collection for creating.
 */
export const createChatRoomCollectionReference = db
    .collection(`chatRooms`)
    .withConverter<CreateChatRoom>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateChatRoom`
            )
        },
        toFirestore: (obj: CreateChatRoom): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a chatRoom document for creating.
 * @param chatRoomId - The ID of the chatRoom document to read.
 */
export const createChatRoomDocumentReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): DocumentReference<CreateChatRoom> =>
    createChatRoomCollectionReference.doc(chatRoomId)

/**
 * Provides a reference to the chatRooms collection for updating.
 */
export const updateChatRoomCollectionReference = db
    .collection(`chatRooms`)
    .withConverter<UpdateChatRoom>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateChatRoom`
            )
        },
        toFirestore: (obj: UpdateChatRoom): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a chatRoom document for updating.
 * @param chatRoomId - The ID of the chatRoom document to read.
 */
export const updateChatRoomDocumentReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): DocumentReference<UpdateChatRoom> =>
    updateChatRoomCollectionReference.doc(chatRoomId)

/**
 * Provides a reference to the chatRooms collection for deleting.
 */
export const deleteChatRoomCollectionReference = db
    .collection(`chatRooms`)
    .withConverter<DeleteChatRoom>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteChatRoom`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(`toFirestore is not implemented for DeleteChatRoom`)
        }
    })

/**
 * Provides a reference to a chatRoom document for deleting.
 * @param chatRoomId - The ID of the chatRoom document to read.
 */
export const deleteChatRoomDocumentReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): DocumentReference<DeleteChatRoom> =>
    deleteChatRoomCollectionReference.doc(chatRoomId)

/**
 * Manages queries against the chatRooms collection.
 */
export class ChatRoomQuery {
    /**
     * Fetches chatRoom documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (query: Query<ReadChatRoom>) => Query<ReadChatRoom>
        compare?: (lhs: ReadChatRoom, rhs: ReadChatRoom) => number
    }): Promise<ReadChatRoom[]> {
        let query: Query<ReadChatRoom> = readChatRoomCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadChatRoom> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadChatRoom>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific chatRoom document.
     * @param chatRoomId - The ID of the chatRoom document to fetch.
     */
    async fetchDocument({
        chatRoomId
    }: {
        chatRoomId: string
    }): Promise<ReadChatRoom | undefined> {
        const ds = await readChatRoomDocumentReference({
            chatRoomId
        }).get()
        return ds.data()
    }

    /**
     * Adds a chatRoom document.
     * @param createChatRoom - The chatRoom details to add.
     */
    async add({
        createChatRoom
    }: {
        createChatRoom: CreateChatRoom
    }): Promise<DocumentReference<CreateChatRoom>> {
        return createChatRoomCollectionReference.add(createChatRoom)
    }

    /**
     * Sets a chatRoom document.
     * @param chatRoomId - The ID of the chatRoom document to set.
     * @param createChatRoom - The chatRoom details to set.
     * @param options - Options for the set operation.
     */
    async set({
        chatRoomId,
        createChatRoom,
        options
    }: {
        chatRoomId: string
        createChatRoom: CreateChatRoom
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createChatRoomDocumentReference({
                chatRoomId
            }).set(createChatRoom)
        } else {
            return createChatRoomDocumentReference({
                chatRoomId
            }).set(createChatRoom, options)
        }
    }

    /**
     * Updates a specific chatRoom document.
     * @param chatRoomId - The ID of the chatRoom document to update.
     * @param updateChatRoom - The details for updating the chatRoom.
     */
    async update({
        chatRoomId,
        updateChatRoom
    }: {
        chatRoomId: string
        updateChatRoom: UpdateChatRoom
    }): Promise<WriteResult> {
        return updateChatRoomDocumentReference({
            chatRoomId
        }).update(updateChatRoom.toJson())
    }

    /**
     * Deletes a specific chatRoom document.
     * @param chatRoomId - The ID of the chatRoom document to delete.
     */
    async delete({ chatRoomId }: { chatRoomId: string }): Promise<WriteResult> {
        return deleteChatRoomDocumentReference({
            chatRoomId
        }).delete()
    }
}
