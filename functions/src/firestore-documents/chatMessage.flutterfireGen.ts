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

export type ChatMessageType = `worker` | `host` | `system`

export class ReadChatMessage {
    constructor({
        chatMessageId,
        path,
        senderId,
        chatMessageType,
        content,
        imageUrls,
        isDeleted,
        createdAt,
        updatedAt
    }: {
        chatMessageId: string
        path: string
        senderId: string
        chatMessageType: ChatMessageType
        content: string
        imageUrls: string[]
        isDeleted: boolean
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.chatMessageId = chatMessageId
        this.path = path
        this.senderId = senderId
        this.chatMessageType = chatMessageType
        this.content = content
        this.imageUrls = imageUrls
        this.isDeleted = isDeleted
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly chatMessageId: string

    readonly path: string

    readonly senderId: string

    readonly chatMessageType: ChatMessageType

    readonly content: string

    readonly imageUrls: string[]

    readonly isDeleted: boolean

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static chatMessageTypeConverterFromJson(
        chatMessageType: string
    ): ChatMessageType {
        return chatMessageType as ChatMessageType
    }

    private static fromJson(json: Record<string, unknown>): ReadChatMessage {
        return new ReadChatMessage({
            chatMessageId: json[`chatMessageId`] as string,
            path: json[`path`] as string,
            senderId: json[`senderId`] as string,
            chatMessageType: ReadChatMessage.chatMessageTypeConverterFromJson(
                json[`chatMessageType`] as string
            ),
            content: (json[`content`] as string | undefined) ?? ``,
            imageUrls:
                (json[`imageUrls`] as unknown[] | undefined)?.map(
                    (e) => e as string
                ) ?? [],
            isDeleted: (json[`isDeleted`] as boolean | undefined) ?? false,
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadChatMessage {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadChatMessage.fromJson({
            ...cleanedData,
            chatMessageId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateChatMessage {
    constructor({
        senderId,
        chatMessageType,
        content,
        imageUrls,
        isDeleted
    }: {
        senderId: string
        chatMessageType: ChatMessageType
        content: string
        imageUrls: string[]
        isDeleted: boolean
    }) {
        this.senderId = senderId
        this.chatMessageType = chatMessageType
        this.content = content
        this.imageUrls = imageUrls
        this.isDeleted = isDeleted
    }

    readonly senderId: string

    readonly chatMessageType: ChatMessageType

    readonly content: string

    readonly imageUrls: string[]

    readonly isDeleted: boolean

    private static chatMessageTypeConverterToJson(
        chatMessageType: ChatMessageType
    ): string {
        return chatMessageType as string
    }

    toJson(): Record<string, unknown> {
        return {
            senderId: this.senderId,
            chatMessageType: CreateChatMessage.chatMessageTypeConverterToJson(
                this.chatMessageType
            ),
            content: this.content,
            imageUrls: this.imageUrls,
            isDeleted: this.isDeleted,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateChatMessage {
    constructor({
        senderId,
        chatMessageType,
        content,
        imageUrls,
        isDeleted,
        createdAt
    }: {
        senderId?: string
        chatMessageType?: ChatMessageType
        content?: string
        imageUrls?: string[]
        isDeleted?: boolean
        createdAt?: Date
    }) {
        this.senderId = senderId
        this.chatMessageType = chatMessageType
        this.content = content
        this.imageUrls = imageUrls
        this.isDeleted = isDeleted
        this.createdAt = createdAt
    }

    readonly senderId?: string

    readonly chatMessageType?: ChatMessageType

    readonly content?: string

    readonly imageUrls?: string[]

    readonly isDeleted?: boolean

    readonly createdAt?: Date

    private static chatMessageTypeConverterToJson(
        chatMessageType: ChatMessageType
    ): string {
        return chatMessageType as string
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.senderId != undefined) {
            json[`senderId`] = this.senderId
        }
        if (this.chatMessageType != undefined) {
            json[`chatMessageType`] =
                UpdateChatMessage.chatMessageTypeConverterToJson(
                    this.chatMessageType
                )
        }
        if (this.content != undefined) {
            json[`content`] = this.content
        }
        if (this.imageUrls != undefined) {
            json[`imageUrls`] = this.imageUrls
        }
        if (this.isDeleted != undefined) {
            json[`isDeleted`] = this.isDeleted
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteChatMessage {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the chatMessages collection for reading.
 */
export const readChatMessageCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<ReadChatMessage> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`chatMessages`)
        .withConverter<ReadChatMessage>({
            fromFirestore: (ds: DocumentSnapshot): ReadChatMessage => {
                return ReadChatMessage.fromDocumentSnapshot(ds)
            },
            toFirestore: () => {
                throw new Error(
                    `toFirestore is not implemented for ReadChatMessage`
                )
            }
        })
}

/**
 * Provides a reference to a chatMessage document for reading.
 * @param chatMessageId - The ID of the chatMessage document to read.
 */
export const readChatMessageDocumentReference = ({
    chatRoomId,
    chatMessageId
}: {
    chatRoomId: string
    chatMessageId: string
}): DocumentReference<ReadChatMessage> =>
    readChatMessageCollectionReference({
        chatRoomId
    }).doc(chatMessageId)

/**
 * Provides a reference to the chatMessages collection for creating.
 */
export const createChatMessageCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<CreateChatMessage> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`chatMessages`)
        .withConverter<CreateChatMessage>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for CreateChatMessage`
                )
            },
            toFirestore: (obj: CreateChatMessage): DocumentData => {
                return obj.toJson()
            }
        })
}

/**
 * Provides a reference to a chatMessage document for creating.
 * @param chatMessageId - The ID of the chatMessage document to read.
 */
export const createChatMessageDocumentReference = ({
    chatRoomId,
    chatMessageId
}: {
    chatRoomId: string
    chatMessageId: string
}): DocumentReference<CreateChatMessage> =>
    createChatMessageCollectionReference({
        chatRoomId
    }).doc(chatMessageId)

/**
 * Provides a reference to the chatMessages collection for updating.
 */
export const updateChatMessageCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<UpdateChatMessage> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`chatMessages`)
        .withConverter<UpdateChatMessage>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for UpdateChatMessage`
                )
            },
            toFirestore: (obj: UpdateChatMessage): DocumentData => {
                return obj.toJson()
            }
        })
}

/**
 * Provides a reference to a chatMessage document for updating.
 * @param chatMessageId - The ID of the chatMessage document to read.
 */
export const updateChatMessageDocumentReference = ({
    chatRoomId,
    chatMessageId
}: {
    chatRoomId: string
    chatMessageId: string
}): DocumentReference<UpdateChatMessage> =>
    updateChatMessageCollectionReference({
        chatRoomId
    }).doc(chatMessageId)

/**
 * Provides a reference to the chatMessages collection for deleting.
 */
export const deleteChatMessageCollectionReference = ({
    chatRoomId
}: {
    chatRoomId: string
}): CollectionReference<DeleteChatMessage> => {
    return db
        .collection(`chatRooms`)
        .doc(chatRoomId)
        .collection(`chatMessages`)
        .withConverter<DeleteChatMessage>({
            fromFirestore: () => {
                throw new Error(
                    `fromFirestore is not implemented for DeleteChatMessage`
                )
            },
            toFirestore: (): DocumentData => {
                throw new Error(
                    `toFirestore is not implemented for DeleteChatMessage`
                )
            }
        })
}

/**
 * Provides a reference to a chatMessage document for deleting.
 * @param chatMessageId - The ID of the chatMessage document to read.
 */
export const deleteChatMessageDocumentReference = ({
    chatRoomId,
    chatMessageId
}: {
    chatRoomId: string
    chatMessageId: string
}): DocumentReference<DeleteChatMessage> =>
    deleteChatMessageCollectionReference({
        chatRoomId
    }).doc(chatMessageId)

/**
 * Manages queries against the chatMessages collection.
 */
export class ChatMessageQuery {
    /**
     * Fetches chatMessage documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        chatRoomId,
        queryBuilder,
        compare
    }: {
        chatRoomId: string
        queryBuilder?: (query: Query<ReadChatMessage>) => Query<ReadChatMessage>
        compare?: (lhs: ReadChatMessage, rhs: ReadChatMessage) => number
    }): Promise<ReadChatMessage[]> {
        let query: Query<ReadChatMessage> = readChatMessageCollectionReference({
            chatRoomId
        })
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadChatMessage> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadChatMessage>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific chatMessage document.
     * @param chatMessageId - The ID of the chatMessage document to fetch.
     */
    async fetchDocument({
        chatRoomId,
        chatMessageId
    }: {
        chatRoomId: string
        chatMessageId: string
    }): Promise<ReadChatMessage | undefined> {
        const ds = await readChatMessageDocumentReference({
            chatRoomId,
            chatMessageId
        }).get()
        return ds.data()
    }

    /**
     * Adds a chatMessage document.
     * @param createChatMessage - The chatMessage details to add.
     */
    async add({
        chatRoomId,
        createChatMessage
    }: {
        chatRoomId: string
        createChatMessage: CreateChatMessage
    }): Promise<DocumentReference<CreateChatMessage>> {
        return createChatMessageCollectionReference({ chatRoomId }).add(
            createChatMessage
        )
    }

    /**
     * Sets a chatMessage document.
     * @param chatMessageId - The ID of the chatMessage document to set.
     * @param createChatMessage - The chatMessage details to set.
     * @param options - Options for the set operation.
     */
    async set({
        chatRoomId,
        chatMessageId,
        createChatMessage,
        options
    }: {
        chatRoomId: string
        chatMessageId: string
        createChatMessage: CreateChatMessage
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createChatMessageDocumentReference({
                chatRoomId,
                chatMessageId
            }).set(createChatMessage)
        } else {
            return createChatMessageDocumentReference({
                chatRoomId,
                chatMessageId
            }).set(createChatMessage, options)
        }
    }

    /**
     * Updates a specific chatMessage document.
     * @param chatMessageId - The ID of the chatMessage document to update.
     * @param updateChatMessage - The details for updating the chatMessage.
     */
    async update({
        chatRoomId,
        chatMessageId,
        updateChatMessage
    }: {
        chatRoomId: string
        chatMessageId: string
        updateChatMessage: UpdateChatMessage
    }): Promise<WriteResult> {
        return updateChatMessageDocumentReference({
            chatRoomId,
            chatMessageId
        }).update(updateChatMessage.toJson())
    }

    /**
     * Deletes a specific chatMessage document.
     * @param chatMessageId - The ID of the chatMessage document to delete.
     */
    async delete({
        chatRoomId,
        chatMessageId
    }: {
        chatRoomId: string
        chatMessageId: string
    }): Promise<WriteResult> {
        return deleteChatMessageDocumentReference({
            chatRoomId,
            chatMessageId
        }).delete()
    }
}
