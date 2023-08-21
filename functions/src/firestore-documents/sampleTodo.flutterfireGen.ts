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

export class ReadSampleTodo {
    constructor({
        sampleTodoId,
        path,
        title,
        description,
        isDone,
        dueDateTime,
        updatedAt
    }: {
        sampleTodoId: string
        path: string
        title: string
        description: string
        isDone: boolean
        dueDateTime: Date
        updatedAt?: Date
    }) {
        this.sampleTodoId = sampleTodoId
        this.path = path
        this.title = title
        this.description = description
        this.isDone = isDone
        this.dueDateTime = dueDateTime
        this.updatedAt = updatedAt
    }

    readonly sampleTodoId: string

    readonly path: string

    readonly title: string

    readonly description: string

    readonly isDone: boolean

    readonly dueDateTime: Date

    readonly updatedAt?: Date

    private static fromJson(json: Record<string, unknown>): ReadSampleTodo {
        return new ReadSampleTodo({
            sampleTodoId: json[`sampleTodoId`] as string,
            path: json[`path`] as string,
            title: (json[`title`] as string | undefined) ?? ``,
            description: (json[`description`] as string | undefined) ?? ``,
            isDone: (json[`isDone`] as boolean | undefined) ?? false,
            dueDateTime: (json[`dueDateTime`] as Timestamp).toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadSampleTodo {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadSampleTodo.fromJson({
            ...cleanedData,
            sampleTodoId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateSampleTodo {
    constructor({
        title,
        description,
        isDone,
        dueDateTime
    }: {
        title: string
        description: string
        isDone: boolean
        dueDateTime: Date
    }) {
        this.title = title
        this.description = description
        this.isDone = isDone
        this.dueDateTime = dueDateTime
    }

    readonly title: string

    readonly description: string

    readonly isDone: boolean

    readonly dueDateTime: Date

    toJson(): Record<string, unknown> {
        return {
            title: this.title,
            description: this.description,
            isDone: this.isDone,
            dueDateTime: this.dueDateTime,
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateSampleTodo {
    constructor({
        title,
        description,
        isDone,
        dueDateTime
    }: {
        title?: string
        description?: string
        isDone?: boolean
        dueDateTime?: Date
    }) {
        this.title = title
        this.description = description
        this.isDone = isDone
        this.dueDateTime = dueDateTime
    }

    readonly title?: string

    readonly description?: string

    readonly isDone?: boolean

    readonly dueDateTime?: Date

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.title != undefined) {
            json[`title`] = this.title
        }
        if (this.description != undefined) {
            json[`description`] = this.description
        }
        if (this.isDone != undefined) {
            json[`isDone`] = this.isDone
        }
        if (this.dueDateTime != undefined) {
            json[`dueDateTime`] = this.dueDateTime
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteSampleTodo {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the sampleTodos collection for reading.
 */
export const readSampleTodoCollectionReference = db
    .collection(`sampleTodos`)
    .withConverter<ReadSampleTodo>({
        fromFirestore: (ds: DocumentSnapshot): ReadSampleTodo => {
            return ReadSampleTodo.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(`toFirestore is not implemented for ReadSampleTodo`)
        }
    })

/**
 * Provides a reference to a sampleTodo document for reading.
 * @param sampleTodoId - The ID of the sampleTodo document to read.
 */
export const readSampleTodoDocumentReference = ({
    sampleTodoId
}: {
    sampleTodoId: string
}): DocumentReference<ReadSampleTodo> =>
    readSampleTodoCollectionReference.doc(sampleTodoId)

/**
 * Provides a reference to the sampleTodos collection for creating.
 */
export const createSampleTodoCollectionReference = db
    .collection(`sampleTodos`)
    .withConverter<CreateSampleTodo>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateSampleTodo`
            )
        },
        toFirestore: (obj: CreateSampleTodo): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a sampleTodo document for creating.
 * @param sampleTodoId - The ID of the sampleTodo document to read.
 */
export const createSampleTodoDocumentReference = ({
    sampleTodoId
}: {
    sampleTodoId: string
}): DocumentReference<CreateSampleTodo> =>
    createSampleTodoCollectionReference.doc(sampleTodoId)

/**
 * Provides a reference to the sampleTodos collection for updating.
 */
export const updateSampleTodoCollectionReference = db
    .collection(`sampleTodos`)
    .withConverter<UpdateSampleTodo>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateSampleTodo`
            )
        },
        toFirestore: (obj: UpdateSampleTodo): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a sampleTodo document for updating.
 * @param sampleTodoId - The ID of the sampleTodo document to read.
 */
export const updateSampleTodoDocumentReference = ({
    sampleTodoId
}: {
    sampleTodoId: string
}): DocumentReference<UpdateSampleTodo> =>
    updateSampleTodoCollectionReference.doc(sampleTodoId)

/**
 * Provides a reference to the sampleTodos collection for deleting.
 */
export const deleteSampleTodoCollectionReference = db
    .collection(`sampleTodos`)
    .withConverter<DeleteSampleTodo>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteSampleTodo`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteSampleTodo`
            )
        }
    })

/**
 * Provides a reference to a sampleTodo document for deleting.
 * @param sampleTodoId - The ID of the sampleTodo document to read.
 */
export const deleteSampleTodoDocumentReference = ({
    sampleTodoId
}: {
    sampleTodoId: string
}): DocumentReference<DeleteSampleTodo> =>
    deleteSampleTodoCollectionReference.doc(sampleTodoId)

/**
 * Manages queries against the sampleTodos collection.
 */
export class SampleTodoQuery {
    /**
     * Fetches sampleTodo documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (query: Query<ReadSampleTodo>) => Query<ReadSampleTodo>
        compare?: (lhs: ReadSampleTodo, rhs: ReadSampleTodo) => number
    }): Promise<ReadSampleTodo[]> {
        let query: Query<ReadSampleTodo> = readSampleTodoCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadSampleTodo> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadSampleTodo>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific sampleTodo document.
     * @param sampleTodoId - The ID of the sampleTodo document to fetch.
     */
    async fetchDocument({
        sampleTodoId
    }: {
        sampleTodoId: string
    }): Promise<ReadSampleTodo | undefined> {
        const ds = await readSampleTodoDocumentReference({
            sampleTodoId
        }).get()
        return ds.data()
    }

    /**
     * Adds a sampleTodo document.
     * @param createSampleTodo - The sampleTodo details to add.
     */
    async add({
        createSampleTodo
    }: {
        createSampleTodo: CreateSampleTodo
    }): Promise<DocumentReference<CreateSampleTodo>> {
        return createSampleTodoCollectionReference.add(createSampleTodo)
    }

    /**
     * Sets a sampleTodo document.
     * @param sampleTodoId - The ID of the sampleTodo document to set.
     * @param createSampleTodo - The sampleTodo details to set.
     * @param options - Options for the set operation.
     */
    async set({
        sampleTodoId,
        createSampleTodo,
        options
    }: {
        sampleTodoId: string
        createSampleTodo: CreateSampleTodo
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createSampleTodoDocumentReference({
                sampleTodoId
            }).set(createSampleTodo)
        } else {
            return createSampleTodoDocumentReference({
                sampleTodoId
            }).set(createSampleTodo, options)
        }
    }

    /**
     * Updates a specific sampleTodo document.
     * @param sampleTodoId - The ID of the sampleTodo document to update.
     * @param updateSampleTodo - The details for updating the sampleTodo.
     */
    async update({
        sampleTodoId,
        updateSampleTodo
    }: {
        sampleTodoId: string
        updateSampleTodo: UpdateSampleTodo
    }): Promise<WriteResult> {
        return updateSampleTodoDocumentReference({
            sampleTodoId
        }).update(updateSampleTodo.toJson())
    }

    /**
     * Deletes a specific sampleTodo document.
     * @param sampleTodoId - The ID of the sampleTodo document to delete.
     */
    async delete({
        sampleTodoId
    }: {
        sampleTodoId: string
    }): Promise<WriteResult> {
        return deleteSampleTodoDocumentReference({
            sampleTodoId
        }).delete()
    }
}
