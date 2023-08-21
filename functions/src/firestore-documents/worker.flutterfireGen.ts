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

export class ReadWorker {
    constructor({
        workerId,
        path,
        displayName,
        imageUrl,
        isHost,
        createdAt,
        updatedAt
    }: {
        workerId: string
        path: string
        displayName: string
        imageUrl: string
        isHost: boolean
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.workerId = workerId
        this.path = path
        this.displayName = displayName
        this.imageUrl = imageUrl
        this.isHost = isHost
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly workerId: string

    readonly path: string

    readonly displayName: string

    readonly imageUrl: string

    readonly isHost: boolean

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static fromJson(json: Record<string, unknown>): ReadWorker {
        return new ReadWorker({
            workerId: json[`workerId`] as string,
            path: json[`path`] as string,
            displayName: (json[`displayName`] as string | undefined) ?? ``,
            imageUrl: (json[`imageUrl`] as string | undefined) ?? ``,
            isHost: (json[`isHost`] as boolean | undefined) ?? false,
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadWorker {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadWorker.fromJson({
            ...cleanedData,
            workerId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateWorker {
    constructor({
        displayName,
        imageUrl,
        isHost
    }: {
        displayName: string
        imageUrl: string
        isHost: boolean
    }) {
        this.displayName = displayName
        this.imageUrl = imageUrl
        this.isHost = isHost
    }

    readonly displayName: string

    readonly imageUrl: string

    readonly isHost: boolean

    toJson(): Record<string, unknown> {
        return {
            displayName: this.displayName,
            imageUrl: this.imageUrl,
            isHost: this.isHost,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateWorker {
    constructor({
        displayName,
        imageUrl,
        isHost,
        createdAt
    }: {
        displayName?: string
        imageUrl?: string
        isHost?: boolean
        createdAt?: Date
    }) {
        this.displayName = displayName
        this.imageUrl = imageUrl
        this.isHost = isHost
        this.createdAt = createdAt
    }

    readonly displayName?: string

    readonly imageUrl?: string

    readonly isHost?: boolean

    readonly createdAt?: Date

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.displayName != undefined) {
            json[`displayName`] = this.displayName
        }
        if (this.imageUrl != undefined) {
            json[`imageUrl`] = this.imageUrl
        }
        if (this.isHost != undefined) {
            json[`isHost`] = this.isHost
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteWorker {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the workers collection for reading.
 */
export const readWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<ReadWorker>({
        fromFirestore: (ds: DocumentSnapshot): ReadWorker => {
            return ReadWorker.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(`toFirestore is not implemented for ReadWorker`)
        }
    })

/**
 * Provides a reference to a worker document for reading.
 * @param workerId - The ID of the worker document to read.
 */
export const readWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): DocumentReference<ReadWorker> => readWorkerCollectionReference.doc(workerId)

/**
 * Provides a reference to the workers collection for creating.
 */
export const createWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<CreateWorker>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for CreateWorker`)
        },
        toFirestore: (obj: CreateWorker): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a worker document for creating.
 * @param workerId - The ID of the worker document to read.
 */
export const createWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): DocumentReference<CreateWorker> =>
    createWorkerCollectionReference.doc(workerId)

/**
 * Provides a reference to the workers collection for updating.
 */
export const updateWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<UpdateWorker>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for UpdateWorker`)
        },
        toFirestore: (obj: UpdateWorker): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a worker document for updating.
 * @param workerId - The ID of the worker document to read.
 */
export const updateWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): DocumentReference<UpdateWorker> =>
    updateWorkerCollectionReference.doc(workerId)

/**
 * Provides a reference to the workers collection for deleting.
 */
export const deleteWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<DeleteWorker>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for DeleteWorker`)
        },
        toFirestore: (): DocumentData => {
            throw new Error(`toFirestore is not implemented for DeleteWorker`)
        }
    })

/**
 * Provides a reference to a worker document for deleting.
 * @param workerId - The ID of the worker document to read.
 */
export const deleteWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): DocumentReference<DeleteWorker> =>
    deleteWorkerCollectionReference.doc(workerId)

/**
 * Manages queries against the workers collection.
 */
export class WorkerQuery {
    /**
     * Fetches worker documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (query: Query<ReadWorker>) => Query<ReadWorker>
        compare?: (lhs: ReadWorker, rhs: ReadWorker) => number
    }): Promise<ReadWorker[]> {
        let query: Query<ReadWorker> = readWorkerCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadWorker> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadWorker>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific worker document.
     * @param workerId - The ID of the worker document to fetch.
     */
    async fetchDocument({
        workerId
    }: {
        workerId: string
    }): Promise<ReadWorker | undefined> {
        const ds = await readWorkerDocumentReference({
            workerId
        }).get()
        return ds.data()
    }

    /**
     * Adds a worker document.
     * @param createWorker - The worker details to add.
     */
    async add({
        createWorker
    }: {
        createWorker: CreateWorker
    }): Promise<DocumentReference<CreateWorker>> {
        return createWorkerCollectionReference.add(createWorker)
    }

    /**
     * Sets a worker document.
     * @param workerId - The ID of the worker document to set.
     * @param createWorker - The worker details to set.
     * @param options - Options for the set operation.
     */
    async set({
        workerId,
        createWorker,
        options
    }: {
        workerId: string
        createWorker: CreateWorker
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createWorkerDocumentReference({
                workerId
            }).set(createWorker)
        } else {
            return createWorkerDocumentReference({
                workerId
            }).set(createWorker, options)
        }
    }

    /**
     * Updates a specific worker document.
     * @param workerId - The ID of the worker document to update.
     * @param updateWorker - The details for updating the worker.
     */
    async update({
        workerId,
        updateWorker
    }: {
        workerId: string
        updateWorker: UpdateWorker
    }): Promise<WriteResult> {
        return updateWorkerDocumentReference({
            workerId
        }).update(updateWorker.toJson())
    }

    /**
     * Deletes a specific worker document.
     * @param workerId - The ID of the worker document to delete.
     */
    async delete({ workerId }: { workerId: string }): Promise<WriteResult> {
        return deleteWorkerDocumentReference({
            workerId
        }).delete()
    }
}
