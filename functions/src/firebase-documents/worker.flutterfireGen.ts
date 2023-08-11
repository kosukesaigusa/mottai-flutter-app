import * as admin from 'firebase-admin'
import {
    DocumentReference,
    FieldValue,
    QueryDocumentSnapshot,
    QuerySnapshot,
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
            createdAt: (
                json[`createdAt`] as FirebaseFirestore.Timestamp | undefined
            )?.toDate(),
            updatedAt: (
                json[`updatedAt`] as FirebaseFirestore.Timestamp | undefined
            )?.toDate()
        })
    }

    static fromDocumentSnapshot(
        ds: FirebaseFirestore.DocumentSnapshot
    ): ReadWorker {
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

    readonly createdAt?: Date

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

    toJson(): Record<string, unknown> {
        const json: Record<string, unknown> = {}
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
            json[`createdAt`] = FirebaseFirestore.Timestamp.fromDate(
                this.createdAt
            )
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * A CollectionReference to the workers collection for reading.
 * @type {FirebaseFirestore.CollectionReference<ReadWorker>}
 */
export const readWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<ReadWorker>({
        fromFirestore: (ds: FirebaseFirestore.DocumentSnapshot): ReadWorker => {
            return ReadWorker.fromDocumentSnapshot(ds)
        },
        toFirestore: (): FirebaseFirestore.DocumentData => {
            throw Error(`toFirestore is not implemented for ReadWorker`)
        }
    })

/**
 * A DocumentReference to a worker document for reading.
 * @param {string} workerId - The ID of the worker document to read.
 * @returns {FirebaseFirestore.DocumentReference<ReadWorker>}
 */
export const readWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): FirebaseFirestore.DocumentReference<ReadWorker> =>
    readWorkerCollectionReference.doc(workerId)

/**
 * A CollectionReference to the workers collection for creating.
 * @type {FirebaseFirestore.CollectionReference<CreateWorker>}
 */
export const createWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<CreateWorker>({
        fromFirestore: (): CreateWorker => {
            throw new Error(`fromFirestore is not implemented for CreateWorker`)
        },
        toFirestore: (obj: CreateWorker): FirebaseFirestore.DocumentData => {
            return obj.toJson()
        }
    })

/**
 * A DocumentReference to a worker document for creating.
 * @param {string} workerId - The ID of the worker document to create.
 * @returns {FirebaseFirestore.DocumentReference<CreateWorker>}
 */
export const createWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): FirebaseFirestore.DocumentReference<CreateWorker> =>
    createWorkerCollectionReference.doc(workerId)

/**
 * A CollectionReference to the workers collection for updating.
 * @type {FirebaseFirestore.CollectionReference<UpdateWorker>}
 */
export const updateWorkerCollectionReference = db
    .collection(`workers`)
    .withConverter<UpdateWorker>({
        fromFirestore: (): CreateWorker => {
            throw new Error(`fromFirestore is not implemented for CreateWorker`)
        },
        toFirestore: (obj: UpdateWorker): FirebaseFirestore.DocumentData => {
            return obj.toJson()
        }
    })

/**
 * A DocumentReference to a worker document for updating.
 * @param {string} workerId - The ID of the worker document to update.
 * @returns {FirebaseFirestore.DocumentReference<UpdateWorker>}
 */
export const updateWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): FirebaseFirestore.DocumentReference<UpdateWorker> =>
    updateWorkerCollectionReference.doc(workerId)

/**
 * A CollectionReference to the workers collection for deleting.
 * @type {FirebaseFirestore.CollectionReference}
 */
export const deleteWorkerCollectionReference = db.collection(`workers`)

/**
 * A DocumentReference to a worker document for deleting.
 * @param {string} workerId - The ID of the worker document to delete.
 * @returns {FirebaseFirestore.DocumentReference}
 */
export const deleteWorkerDocumentReference = ({
    workerId
}: {
    workerId: string
}): FirebaseFirestore.DocumentReference =>
    deleteWorkerCollectionReference.doc(workerId)

/**
 * A query manager to execute queries against the Worker collection.
 */
export class WorkerQuery {
    /**
     * Fetches ReadWorker documents.
     * @param {Object} options - Options for the query.
     * @param {Function} options.queryBuilder - A function to build the query.
     * @param {Function} options.compare - A function to compare the results.
     * @returns {Promise<ReadWorker[]>}
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: FirebaseFirestore.Query<ReadWorker>
        ) => FirebaseFirestore.Query<ReadWorker>
        compare?: (lhs: ReadWorker, rhs: ReadWorker) => number
    } = {}): Promise<ReadWorker[]> {
        let query: FirebaseFirestore.Query<ReadWorker> =
            readWorkerCollectionReference
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
     * Fetches a specified ReadWorker document.
     * @param {Object} options - Options for the query.
     * @param {string} options.workerId - The ID of the worker document to fetch.
     * @returns {Promise<ReadWorker | undefined>}
     */
    async fetchDocument({
        workerId
    }: {
        workerId: string
    }): Promise<ReadWorker | undefined> {
        const ds = await readWorkerDocumentReference({ workerId }).get()
        return ds.data()
    }

    /**
     * Adds a Worker document.
     * @param {Object} options - Options for the query.
     * @param {CreateWorker} options.createWorker - The worker document to add.
     * @returns {Promise<DocumentReference<CreateWorker>>}
     */
    async add({
        createWorker
    }: {
        createWorker: CreateWorker
    }): Promise<DocumentReference<CreateWorker>> {
        return createWorkerCollectionReference.add(createWorker)
    }

    /**
     * Sets a Worker document.
     * @param {Object} options - Options for the query.
     * @param {string} options.workerId - The ID of the worker document to set.
     * @param {CreateWorker} options.createWorker - The worker document to set.
     * @param {FirebaseFirestore.SetOptions} options.options - Options for the set operation.
     * @returns {Promise<WriteResult>}
     */
    async set({
        workerId,
        createWorker,
        options
    }: {
        workerId: string
        createWorker: CreateWorker
        options?: FirebaseFirestore.SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createWorkerDocumentReference({ workerId }).set(createWorker)
        } else {
            return createWorkerDocumentReference({ workerId }).set(
                createWorker,
                options
            )
        }
    }

    /**
     * Updates a specified Worker document.
     * @param {Object} options - Options for the query.
     * @param {string} options.workerId - The ID of the worker document to update.
     * @param {UpdateWorker} options.updateWorker - The worker document to update.
     * @returns {Promise<WriteResult>}
     */
    async update({
        workerId,
        updateWorker
    }: {
        workerId: string
        updateWorker: UpdateWorker
    }): Promise<WriteResult> {
        return updateWorkerDocumentReference({ workerId }).update(
            updateWorker.toJson()
        )
    }

    /**
     * Deletes a specified Worker document.
     * @param {Object} options - Options for the query.
     * @param {string} options.workerId - The ID of the worker document to delete.
     * @returns {Promise<WriteResult>}
     */
    async delete({ workerId }: { workerId: string }): Promise<WriteResult> {
        return deleteWorkerDocumentReference({ workerId }).delete()
    }
}
