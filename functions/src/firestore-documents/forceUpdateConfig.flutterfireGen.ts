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

export class ReadForceUpdateConfig {
    constructor({
        forceUpdateConfigId,
        path,
        iOSLatestVersion,
        iOSMinRequiredVersion,
        iOSForceUpdate,
        androidLatestVersion,
        androidMinRequiredVersion,
        androidForceUpdate
    }: {
        forceUpdateConfigId: string
        path: string
        iOSLatestVersion: string
        iOSMinRequiredVersion: string
        iOSForceUpdate: boolean
        androidLatestVersion: string
        androidMinRequiredVersion: string
        androidForceUpdate: boolean
    }) {
        this.forceUpdateConfigId = forceUpdateConfigId
        this.path = path
        this.iOSLatestVersion = iOSLatestVersion
        this.iOSMinRequiredVersion = iOSMinRequiredVersion
        this.iOSForceUpdate = iOSForceUpdate
        this.androidLatestVersion = androidLatestVersion
        this.androidMinRequiredVersion = androidMinRequiredVersion
        this.androidForceUpdate = androidForceUpdate
    }

    readonly forceUpdateConfigId: string

    readonly path: string

    readonly iOSLatestVersion: string

    readonly iOSMinRequiredVersion: string

    readonly iOSForceUpdate: boolean

    readonly androidLatestVersion: string

    readonly androidMinRequiredVersion: string

    readonly androidForceUpdate: boolean

    private static fromJson(
        json: Record<string, unknown>
    ): ReadForceUpdateConfig {
        return new ReadForceUpdateConfig({
            forceUpdateConfigId: json[`forceUpdateConfigId`] as string,
            path: json[`path`] as string,
            iOSLatestVersion: json[`iOSLatestVersion`] as string,
            iOSMinRequiredVersion: json[`iOSMinRequiredVersion`] as string,
            iOSForceUpdate:
                (json[`iOSForceUpdate`] as boolean | undefined) ?? false,
            androidLatestVersion: json[`androidLatestVersion`] as string,
            androidMinRequiredVersion: json[
                `androidMinRequiredVersion`
            ] as string,
            androidForceUpdate:
                (json[`androidForceUpdate`] as boolean | undefined) ?? false
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadForceUpdateConfig {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadForceUpdateConfig.fromJson({
            ...cleanedData,
            forceUpdateConfigId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateForceUpdateConfig {
    constructor({
        iOSLatestVersion,
        iOSMinRequiredVersion,
        iOSForceUpdate,
        androidLatestVersion,
        androidMinRequiredVersion,
        androidForceUpdate
    }: {
        iOSLatestVersion: string
        iOSMinRequiredVersion: string
        iOSForceUpdate: boolean
        androidLatestVersion: string
        androidMinRequiredVersion: string
        androidForceUpdate: boolean
    }) {
        this.iOSLatestVersion = iOSLatestVersion
        this.iOSMinRequiredVersion = iOSMinRequiredVersion
        this.iOSForceUpdate = iOSForceUpdate
        this.androidLatestVersion = androidLatestVersion
        this.androidMinRequiredVersion = androidMinRequiredVersion
        this.androidForceUpdate = androidForceUpdate
    }

    readonly iOSLatestVersion: string

    readonly iOSMinRequiredVersion: string

    readonly iOSForceUpdate: boolean

    readonly androidLatestVersion: string

    readonly androidMinRequiredVersion: string

    readonly androidForceUpdate: boolean

    toJson(): Record<string, unknown> {
        return {
            iOSLatestVersion: this.iOSLatestVersion,
            iOSMinRequiredVersion: this.iOSMinRequiredVersion,
            iOSForceUpdate: this.iOSForceUpdate,
            androidLatestVersion: this.androidLatestVersion,
            androidMinRequiredVersion: this.androidMinRequiredVersion,
            androidForceUpdate: this.androidForceUpdate
        }
    }
}

export class UpdateForceUpdateConfig {
    constructor({
        iOSLatestVersion,
        iOSMinRequiredVersion,
        iOSForceUpdate,
        androidLatestVersion,
        androidMinRequiredVersion,
        androidForceUpdate
    }: {
        iOSLatestVersion?: string
        iOSMinRequiredVersion?: string
        iOSForceUpdate?: boolean
        androidLatestVersion?: string
        androidMinRequiredVersion?: string
        androidForceUpdate?: boolean
    }) {
        this.iOSLatestVersion = iOSLatestVersion
        this.iOSMinRequiredVersion = iOSMinRequiredVersion
        this.iOSForceUpdate = iOSForceUpdate
        this.androidLatestVersion = androidLatestVersion
        this.androidMinRequiredVersion = androidMinRequiredVersion
        this.androidForceUpdate = androidForceUpdate
    }

    readonly iOSLatestVersion?: string

    readonly iOSMinRequiredVersion?: string

    readonly iOSForceUpdate?: boolean

    readonly androidLatestVersion?: string

    readonly androidMinRequiredVersion?: string

    readonly androidForceUpdate?: boolean

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.iOSLatestVersion != undefined) {
            json[`iOSLatestVersion`] = this.iOSLatestVersion
        }
        if (this.iOSMinRequiredVersion != undefined) {
            json[`iOSMinRequiredVersion`] = this.iOSMinRequiredVersion
        }
        if (this.iOSForceUpdate != undefined) {
            json[`iOSForceUpdate`] = this.iOSForceUpdate
        }
        if (this.androidLatestVersion != undefined) {
            json[`androidLatestVersion`] = this.androidLatestVersion
        }
        if (this.androidMinRequiredVersion != undefined) {
            json[`androidMinRequiredVersion`] = this.androidMinRequiredVersion
        }
        if (this.androidForceUpdate != undefined) {
            json[`androidForceUpdate`] = this.androidForceUpdate
        }

        return json
    }
}

export class DeleteForceUpdateConfig {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the configurations collection for reading.
 */
export const readForceUpdateConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<ReadForceUpdateConfig>({
        fromFirestore: (ds: DocumentSnapshot): ReadForceUpdateConfig => {
            return ReadForceUpdateConfig.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(
                `toFirestore is not implemented for ReadForceUpdateConfig`
            )
        }
    })

/**
 * Provides a reference to a forceUpdateConfig document for reading.
 * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to read.
 */
export const readForceUpdateConfigDocumentReference = ({
    forceUpdateConfigId
}: {
    forceUpdateConfigId: string
}): DocumentReference<ReadForceUpdateConfig> =>
    readForceUpdateConfigCollectionReference.doc(forceUpdateConfigId)

/**
 * Provides a reference to the configurations collection for creating.
 */
export const createForceUpdateConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<CreateForceUpdateConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateForceUpdateConfig`
            )
        },
        toFirestore: (obj: CreateForceUpdateConfig): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a forceUpdateConfig document for creating.
 * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to read.
 */
export const createForceUpdateConfigDocumentReference = ({
    forceUpdateConfigId
}: {
    forceUpdateConfigId: string
}): DocumentReference<CreateForceUpdateConfig> =>
    createForceUpdateConfigCollectionReference.doc(forceUpdateConfigId)

/**
 * Provides a reference to the configurations collection for updating.
 */
export const updateForceUpdateConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<UpdateForceUpdateConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateForceUpdateConfig`
            )
        },
        toFirestore: (obj: UpdateForceUpdateConfig): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a forceUpdateConfig document for updating.
 * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to read.
 */
export const updateForceUpdateConfigDocumentReference = ({
    forceUpdateConfigId
}: {
    forceUpdateConfigId: string
}): DocumentReference<UpdateForceUpdateConfig> =>
    updateForceUpdateConfigCollectionReference.doc(forceUpdateConfigId)

/**
 * Provides a reference to the configurations collection for deleting.
 */
export const deleteForceUpdateConfigCollectionReference = db
    .collection(`configurations`)
    .withConverter<DeleteForceUpdateConfig>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteForceUpdateConfig`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteForceUpdateConfig`
            )
        }
    })

/**
 * Provides a reference to a forceUpdateConfig document for deleting.
 * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to read.
 */
export const deleteForceUpdateConfigDocumentReference = ({
    forceUpdateConfigId
}: {
    forceUpdateConfigId: string
}): DocumentReference<DeleteForceUpdateConfig> =>
    deleteForceUpdateConfigCollectionReference.doc(forceUpdateConfigId)

/**
 * Manages queries against the configurations collection.
 */
export class ForceUpdateConfigQuery {
    /**
     * Fetches forceUpdateConfig documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: Query<ReadForceUpdateConfig>
        ) => Query<ReadForceUpdateConfig>
        compare?: (
            lhs: ReadForceUpdateConfig,
            rhs: ReadForceUpdateConfig
        ) => number
    }): Promise<ReadForceUpdateConfig[]> {
        let query: Query<ReadForceUpdateConfig> =
            readForceUpdateConfigCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadForceUpdateConfig> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadForceUpdateConfig>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific forceUpdateConfig document.
     * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to fetch.
     */
    async fetchDocument({
        forceUpdateConfigId
    }: {
        forceUpdateConfigId: string
    }): Promise<ReadForceUpdateConfig | undefined> {
        const ds = await readForceUpdateConfigDocumentReference({
            forceUpdateConfigId
        }).get()
        return ds.data()
    }

    /**
     * Adds a forceUpdateConfig document.
     * @param createForceUpdateConfig - The forceUpdateConfig details to add.
     */
    async add({
        createForceUpdateConfig
    }: {
        createForceUpdateConfig: CreateForceUpdateConfig
    }): Promise<DocumentReference<CreateForceUpdateConfig>> {
        return createForceUpdateConfigCollectionReference.add(
            createForceUpdateConfig
        )
    }

    /**
     * Sets a forceUpdateConfig document.
     * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to set.
     * @param createForceUpdateConfig - The forceUpdateConfig details to set.
     * @param options - Options for the set operation.
     */
    async set({
        forceUpdateConfigId,
        createForceUpdateConfig,
        options
    }: {
        forceUpdateConfigId: string
        createForceUpdateConfig: CreateForceUpdateConfig
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createForceUpdateConfigDocumentReference({
                forceUpdateConfigId
            }).set(createForceUpdateConfig)
        } else {
            return createForceUpdateConfigDocumentReference({
                forceUpdateConfigId
            }).set(createForceUpdateConfig, options)
        }
    }

    /**
     * Updates a specific forceUpdateConfig document.
     * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to update.
     * @param updateForceUpdateConfig - The details for updating the forceUpdateConfig.
     */
    async update({
        forceUpdateConfigId,
        updateForceUpdateConfig
    }: {
        forceUpdateConfigId: string
        updateForceUpdateConfig: UpdateForceUpdateConfig
    }): Promise<WriteResult> {
        return updateForceUpdateConfigDocumentReference({
            forceUpdateConfigId
        }).update(updateForceUpdateConfig.toJson())
    }

    /**
     * Deletes a specific forceUpdateConfig document.
     * @param forceUpdateConfigId - The ID of the forceUpdateConfig document to delete.
     */
    async delete({
        forceUpdateConfigId
    }: {
        forceUpdateConfigId: string
    }): Promise<WriteResult> {
        return deleteForceUpdateConfigDocumentReference({
            forceUpdateConfigId
        }).delete()
    }
}
