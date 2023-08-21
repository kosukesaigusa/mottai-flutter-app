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

export type HostType = `farmer` | `fisherman` | `hunter` | `other`

export class ReadHost {
    constructor({
        hostId,
        path,
        imageUrl,
        displayName,
        introduction,
        hostTypes,
        urls,
        createdAt,
        updatedAt
    }: {
        hostId: string
        path: string
        imageUrl: string
        displayName: string
        introduction: string
        hostTypes: Set<HostType>
        urls: string[]
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.hostId = hostId
        this.path = path
        this.imageUrl = imageUrl
        this.displayName = displayName
        this.introduction = introduction
        this.hostTypes = hostTypes
        this.urls = urls
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly hostId: string

    readonly path: string

    readonly imageUrl: string

    readonly displayName: string

    readonly introduction: string

    readonly hostTypes: Set<HostType>

    readonly urls: string[]

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static hostTypesConverterFromJson(
        hostTypes: unknown[] | undefined
    ): Set<HostType> {
        return new Set((hostTypes ?? []).map((e) => e as HostType))
    }

    private static fromJson(json: Record<string, unknown>): ReadHost {
        return new ReadHost({
            hostId: json[`hostId`] as string,
            path: json[`path`] as string,
            imageUrl: (json[`imageUrl`] as string | undefined) ?? ``,
            displayName: (json[`displayName`] as string | undefined) ?? ``,
            introduction: (json[`introduction`] as string | undefined) ?? ``,
            hostTypes:
                json[`hostTypes`] == undefined
                    ? new Set()
                    : ReadHost.hostTypesConverterFromJson(
                          json[`hostTypes`] as unknown[]
                      ),
            urls:
                (json[`urls`] as unknown[] | undefined)?.map(
                    (e) => e as string
                ) ?? [],
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadHost {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadHost.fromJson({
            ...cleanedData,
            hostId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateHost {
    constructor({
        imageUrl,
        displayName,
        introduction,
        hostTypes,
        urls
    }: {
        imageUrl: string
        displayName: string
        introduction: string
        hostTypes: Set<HostType>
        urls: string[]
    }) {
        this.imageUrl = imageUrl
        this.displayName = displayName
        this.introduction = introduction
        this.hostTypes = hostTypes
        this.urls = urls
    }

    readonly imageUrl: string

    readonly displayName: string

    readonly introduction: string

    readonly hostTypes: Set<HostType>

    readonly urls: string[]

    private static hostTypesConverterToJson(
        hostTypes: Set<HostType>
    ): string[] {
        return [...hostTypes]
    }

    toJson(): Record<string, unknown> {
        return {
            imageUrl: this.imageUrl,
            displayName: this.displayName,
            introduction: this.introduction,
            hostTypes: CreateHost.hostTypesConverterToJson(this.hostTypes),
            urls: this.urls,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateHost {
    constructor({
        imageUrl,
        displayName,
        introduction,
        hostTypes,
        urls,
        createdAt
    }: {
        imageUrl?: string
        displayName?: string
        introduction?: string
        hostTypes?: Set<HostType>
        urls?: string[]
        createdAt?: Date
    }) {
        this.imageUrl = imageUrl
        this.displayName = displayName
        this.introduction = introduction
        this.hostTypes = hostTypes
        this.urls = urls
        this.createdAt = createdAt
    }

    readonly imageUrl?: string

    readonly displayName?: string

    readonly introduction?: string

    readonly hostTypes?: Set<HostType>

    readonly urls?: string[]

    readonly createdAt?: Date

    private static hostTypesConverterToJson(
        hostTypes: Set<HostType>
    ): string[] {
        return [...hostTypes]
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.imageUrl != undefined) {
            json[`imageUrl`] = this.imageUrl
        }
        if (this.displayName != undefined) {
            json[`displayName`] = this.displayName
        }
        if (this.introduction != undefined) {
            json[`introduction`] = this.introduction
        }
        if (this.hostTypes != undefined) {
            json[`hostTypes`] = UpdateHost.hostTypesConverterToJson(
                this.hostTypes
            )
        }
        if (this.urls != undefined) {
            json[`urls`] = this.urls
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteHost {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the hosts collection for reading.
 */
export const readHostCollectionReference = db
    .collection(`hosts`)
    .withConverter<ReadHost>({
        fromFirestore: (ds: DocumentSnapshot): ReadHost => {
            return ReadHost.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(`toFirestore is not implemented for ReadHost`)
        }
    })

/**
 * Provides a reference to a host document for reading.
 * @param hostId - The ID of the host document to read.
 */
export const readHostDocumentReference = ({
    hostId
}: {
    hostId: string
}): DocumentReference<ReadHost> => readHostCollectionReference.doc(hostId)

/**
 * Provides a reference to the hosts collection for creating.
 */
export const createHostCollectionReference = db
    .collection(`hosts`)
    .withConverter<CreateHost>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for CreateHost`)
        },
        toFirestore: (obj: CreateHost): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a host document for creating.
 * @param hostId - The ID of the host document to read.
 */
export const createHostDocumentReference = ({
    hostId
}: {
    hostId: string
}): DocumentReference<CreateHost> => createHostCollectionReference.doc(hostId)

/**
 * Provides a reference to the hosts collection for updating.
 */
export const updateHostCollectionReference = db
    .collection(`hosts`)
    .withConverter<UpdateHost>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for UpdateHost`)
        },
        toFirestore: (obj: UpdateHost): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a host document for updating.
 * @param hostId - The ID of the host document to read.
 */
export const updateHostDocumentReference = ({
    hostId
}: {
    hostId: string
}): DocumentReference<UpdateHost> => updateHostCollectionReference.doc(hostId)

/**
 * Provides a reference to the hosts collection for deleting.
 */
export const deleteHostCollectionReference = db
    .collection(`hosts`)
    .withConverter<DeleteHost>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for DeleteHost`)
        },
        toFirestore: (): DocumentData => {
            throw new Error(`toFirestore is not implemented for DeleteHost`)
        }
    })

/**
 * Provides a reference to a host document for deleting.
 * @param hostId - The ID of the host document to read.
 */
export const deleteHostDocumentReference = ({
    hostId
}: {
    hostId: string
}): DocumentReference<DeleteHost> => deleteHostCollectionReference.doc(hostId)

/**
 * Manages queries against the hosts collection.
 */
export class HostQuery {
    /**
     * Fetches host documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (query: Query<ReadHost>) => Query<ReadHost>
        compare?: (lhs: ReadHost, rhs: ReadHost) => number
    }): Promise<ReadHost[]> {
        let query: Query<ReadHost> = readHostCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadHost> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadHost>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific host document.
     * @param hostId - The ID of the host document to fetch.
     */
    async fetchDocument({
        hostId
    }: {
        hostId: string
    }): Promise<ReadHost | undefined> {
        const ds = await readHostDocumentReference({
            hostId
        }).get()
        return ds.data()
    }

    /**
     * Adds a host document.
     * @param createHost - The host details to add.
     */
    async add({
        createHost
    }: {
        createHost: CreateHost
    }): Promise<DocumentReference<CreateHost>> {
        return createHostCollectionReference.add(createHost)
    }

    /**
     * Sets a host document.
     * @param hostId - The ID of the host document to set.
     * @param createHost - The host details to set.
     * @param options - Options for the set operation.
     */
    async set({
        hostId,
        createHost,
        options
    }: {
        hostId: string
        createHost: CreateHost
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createHostDocumentReference({
                hostId
            }).set(createHost)
        } else {
            return createHostDocumentReference({
                hostId
            }).set(createHost, options)
        }
    }

    /**
     * Updates a specific host document.
     * @param hostId - The ID of the host document to update.
     * @param updateHost - The details for updating the host.
     */
    async update({
        hostId,
        updateHost
    }: {
        hostId: string
        updateHost: UpdateHost
    }): Promise<WriteResult> {
        return updateHostDocumentReference({
            hostId
        }).update(updateHost.toJson())
    }

    /**
     * Deletes a specific host document.
     * @param hostId - The ID of the host document to delete.
     */
    async delete({ hostId }: { hostId: string }): Promise<WriteResult> {
        return deleteHostDocumentReference({
            hostId
        }).delete()
    }
}
