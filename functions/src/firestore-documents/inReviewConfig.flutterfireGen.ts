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

export class ReadInReviewConfig {
    constructor({
        inReviewConfigId,
        path,
        iOSInReviewVersion,
        enableIOSInReviewMode,
        androidInReviewVersion,
        enableAndroidInReviewMode
    }: {
        inReviewConfigId: string
        path: string
        iOSInReviewVersion: string
        enableIOSInReviewMode: boolean
        androidInReviewVersion: string
        enableAndroidInReviewMode: boolean
    }) {
        this.inReviewConfigId = inReviewConfigId
        this.path = path
        this.iOSInReviewVersion = iOSInReviewVersion
        this.enableIOSInReviewMode = enableIOSInReviewMode
        this.androidInReviewVersion = androidInReviewVersion
        this.enableAndroidInReviewMode = enableAndroidInReviewMode
    }

    readonly inReviewConfigId: string

    readonly path: string

    readonly iOSInReviewVersion: string

    readonly enableIOSInReviewMode: boolean

    readonly androidInReviewVersion: string

    readonly enableAndroidInReviewMode: boolean

    private static fromJson(json: Record<string, unknown>): ReadInReviewConfig {
        return new ReadInReviewConfig({
            inReviewConfigId: json[`inReviewConfigId`] as string,
            path: json[`path`] as string,
            iOSInReviewVersion:
                (json[`iOSInReviewVersion`] as string | undefined) ?? `1.0.0`,
            enableIOSInReviewMode:
                (json[`enableIOSInReviewMode`] as boolean | undefined) ?? false,
            androidInReviewVersion:
                (json[`androidInReviewVersion`] as string | undefined) ??
                `1.0.0`,
            enableAndroidInReviewMode:
                (json[`enableAndroidInReviewMode`] as boolean | undefined) ??
                false
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadInReviewConfig {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadInReviewConfig.fromJson({
            ...cleanedData,
            inReviewConfigId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateInReviewConfig {
    constructor({
        iOSInReviewVersion,
        enableIOSInReviewMode,
        androidInReviewVersion,
        enableAndroidInReviewMode
    }: {
        iOSInReviewVersion: string
        enableIOSInReviewMode: boolean
        androidInReviewVersion: string
        enableAndroidInReviewMode: boolean
    }) {
        this.iOSInReviewVersion = iOSInReviewVersion
        this.enableIOSInReviewMode = enableIOSInReviewMode
        this.androidInReviewVersion = androidInReviewVersion
        this.enableAndroidInReviewMode = enableAndroidInReviewMode
    }

    readonly iOSInReviewVersion: string

    readonly enableIOSInReviewMode: boolean

    readonly androidInReviewVersion: string

    readonly enableAndroidInReviewMode: boolean

    toJson(): Record<string, unknown> {
        return {
            iOSInReviewVersion: this.iOSInReviewVersion,
            enableIOSInReviewMode: this.enableIOSInReviewMode,
            androidInReviewVersion: this.androidInReviewVersion,
            enableAndroidInReviewMode: this.enableAndroidInReviewMode
        }
    }
}

export class UpdateInReviewConfig {
    constructor({
        iOSInReviewVersion,
        enableIOSInReviewMode,
        androidInReviewVersion,
        enableAndroidInReviewMode
    }: {
        iOSInReviewVersion?: string
        enableIOSInReviewMode?: boolean
        androidInReviewVersion?: string
        enableAndroidInReviewMode?: boolean
    }) {
        this.iOSInReviewVersion = iOSInReviewVersion
        this.enableIOSInReviewMode = enableIOSInReviewMode
        this.androidInReviewVersion = androidInReviewVersion
        this.enableAndroidInReviewMode = enableAndroidInReviewMode
    }

    readonly iOSInReviewVersion?: string

    readonly enableIOSInReviewMode?: boolean

    readonly androidInReviewVersion?: string

    readonly enableAndroidInReviewMode?: boolean

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.iOSInReviewVersion != undefined) {
            json[`iOSInReviewVersion`] = this.iOSInReviewVersion
        }
        if (this.enableIOSInReviewMode != undefined) {
            json[`enableIOSInReviewMode`] = this.enableIOSInReviewMode
        }
        if (this.androidInReviewVersion != undefined) {
            json[`androidInReviewVersion`] = this.androidInReviewVersion
        }
        if (this.enableAndroidInReviewMode != undefined) {
            json[`enableAndroidInReviewMode`] = this.enableAndroidInReviewMode
        }

        return json
    }
}

export class DeleteInReviewConfig {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the configurations collection for reading.
 */
export const readInReviewConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<ReadInReviewConfig>({
        fromFirestore: (ds: DocumentSnapshot): ReadInReviewConfig => {
            return ReadInReviewConfig.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(
                `toFirestore is not implemented for ReadInReviewConfig`
            )
        }
    })

/**
 * Provides a reference to a inReviewConfig document for reading.
 * @param inReviewConfigId - The ID of the inReviewConfig document to read.
 */
export const readInReviewConfigDocumentReference = ({
    inReviewConfigId
}: {
    inReviewConfigId: string
}): DocumentReference<ReadInReviewConfig> =>
    readInReviewConfigCollectionReference.doc(inReviewConfigId)

/**
 * Provides a reference to the configurations collection for creating.
 */
export const createInReviewConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<CreateInReviewConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateInReviewConfig`
            )
        },
        toFirestore: (obj: CreateInReviewConfig): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a inReviewConfig document for creating.
 * @param inReviewConfigId - The ID of the inReviewConfig document to read.
 */
export const createInReviewConfigDocumentReference = ({
    inReviewConfigId
}: {
    inReviewConfigId: string
}): DocumentReference<CreateInReviewConfig> =>
    createInReviewConfigCollectionReference.doc(inReviewConfigId)

/**
 * Provides a reference to the configurations collection for updating.
 */
export const updateInReviewConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<UpdateInReviewConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateInReviewConfig`
            )
        },
        toFirestore: (obj: UpdateInReviewConfig): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a inReviewConfig document for updating.
 * @param inReviewConfigId - The ID of the inReviewConfig document to read.
 */
export const updateInReviewConfigDocumentReference = ({
    inReviewConfigId
}: {
    inReviewConfigId: string
}): DocumentReference<UpdateInReviewConfig> =>
    updateInReviewConfigCollectionReference.doc(inReviewConfigId)

/**
 * Provides a reference to the configurations collection for deleting.
 */
export const deleteInReviewConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<DeleteInReviewConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteInReviewConfig`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteInReviewConfig`
            )
        }
    })

/**
 * Provides a reference to a inReviewConfig document for deleting.
 * @param inReviewConfigId - The ID of the inReviewConfig document to read.
 */
export const deleteInReviewConfigDocumentReference = ({
    inReviewConfigId
}: {
    inReviewConfigId: string
}): DocumentReference<DeleteInReviewConfig> =>
    deleteInReviewConfigCollectionReference.doc(inReviewConfigId)

/**
 * Manages queries against the configurations collection.
 */
export class InReviewConfigQuery {
    /**
     * Fetches inReviewConfig documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: Query<ReadInReviewConfig>
        ) => Query<ReadInReviewConfig>
        compare?: (lhs: ReadInReviewConfig, rhs: ReadInReviewConfig) => number
    }): Promise<ReadInReviewConfig[]> {
        let query: Query<ReadInReviewConfig> =
            readInReviewConfigCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadInReviewConfig> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadInReviewConfig>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific inReviewConfig document.
     * @param inReviewConfigId - The ID of the inReviewConfig document to fetch.
     */
    async fetchDocument({
        inReviewConfigId
    }: {
        inReviewConfigId: string
    }): Promise<ReadInReviewConfig | undefined> {
        const ds = await readInReviewConfigDocumentReference({
            inReviewConfigId
        }).get()
        return ds.data()
    }

    /**
     * Adds a inReviewConfig document.
     * @param createInReviewConfig - The inReviewConfig details to add.
     */
    async add({
        createInReviewConfig
    }: {
        createInReviewConfig: CreateInReviewConfig
    }): Promise<DocumentReference<CreateInReviewConfig>> {
        return createInReviewConfigCollectionReference.add(createInReviewConfig)
    }

    /**
     * Sets a inReviewConfig document.
     * @param inReviewConfigId - The ID of the inReviewConfig document to set.
     * @param createInReviewConfig - The inReviewConfig details to set.
     * @param options - Options for the set operation.
     */
    async set({
        inReviewConfigId,
        createInReviewConfig,
        options
    }: {
        inReviewConfigId: string
        createInReviewConfig: CreateInReviewConfig
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createInReviewConfigDocumentReference({
                inReviewConfigId
            }).set(createInReviewConfig)
        } else {
            return createInReviewConfigDocumentReference({
                inReviewConfigId
            }).set(createInReviewConfig, options)
        }
    }

    /**
     * Updates a specific inReviewConfig document.
     * @param inReviewConfigId - The ID of the inReviewConfig document to update.
     * @param updateInReviewConfig - The details for updating the inReviewConfig.
     */
    async update({
        inReviewConfigId,
        updateInReviewConfig
    }: {
        inReviewConfigId: string
        updateInReviewConfig: UpdateInReviewConfig
    }): Promise<WriteResult> {
        return updateInReviewConfigDocumentReference({
            inReviewConfigId
        }).update(updateInReviewConfig.toJson())
    }

    /**
     * Deletes a specific inReviewConfig document.
     * @param inReviewConfigId - The ID of the inReviewConfig document to delete.
     */
    async delete({
        inReviewConfigId
    }: {
        inReviewConfigId: string
    }): Promise<WriteResult> {
        return deleteInReviewConfigDocumentReference({
            inReviewConfigId
        }).delete()
    }
}
