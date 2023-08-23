import * as admin from 'firebase-admin'
import {
    DocumentData,
    DocumentReference,
    DocumentSnapshot,
    FieldValue,
    GeoPoint,
    Query,
    QueryDocumentSnapshot,
    QuerySnapshot,
    SetOptions,
    Timestamp,
    WriteResult
} from 'firebase-admin/firestore'

export class Geo {
    constructor({
        geohash,
        geopoint
    }: {
        geohash: string
        geopoint: GeoPoint
    }) {
        this.geohash = geohash
        this.geopoint = geopoint
    }

    readonly geohash: string

    readonly geopoint: GeoPoint
}

export class ReadHostLocation {
    constructor({
        hostLocationId,
        path,
        hostId,
        address,
        geo,
        createdAt,
        updatedAt
    }: {
        hostLocationId: string
        path: string
        hostId: string
        address: string
        geo: Geo
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.hostLocationId = hostLocationId
        this.path = path
        this.hostId = hostId
        this.address = address
        this.geo = geo
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly hostLocationId: string

    readonly path: string

    readonly hostId: string

    readonly address: string

    readonly geo: Geo

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static geoConverterFromJson(json: Record<string, unknown>): Geo {
        const geohash = json[`geohash`] as string
        const geopoint = json[`geopoint`] as GeoPoint
        return new Geo({ geohash, geopoint })
    }

    private static fromJson(json: Record<string, unknown>): ReadHostLocation {
        return new ReadHostLocation({
            hostLocationId: json[`hostLocationId`] as string,
            path: json[`path`] as string,
            hostId: json[`hostId`] as string,
            address: (json[`address`] as string | undefined) ?? ``,
            geo: ReadHostLocation.geoConverterFromJson(
                json[`geo`] as Record<string, unknown>
            ),
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadHostLocation {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadHostLocation.fromJson({
            ...cleanedData,
            hostLocationId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateHostLocation {
    constructor({
        hostId,
        address,
        geo
    }: {
        hostId: string
        address: string
        geo: Geo
    }) {
        this.hostId = hostId
        this.address = address
        this.geo = geo
    }

    readonly hostId: string

    readonly address: string

    readonly geo: Geo

    private static geoConverterToJson(geo: Geo): Record<string, unknown> {
        return {
            geohash: geo.geohash,
            geopoint: geo.geopoint
        }
    }

    toJson(): Record<string, unknown> {
        return {
            hostId: this.hostId,
            address: this.address,
            geo: CreateHostLocation.geoConverterToJson(this.geo),
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateHostLocation {
    constructor({
        hostId,
        address,
        geo,
        createdAt
    }: {
        hostId?: string
        address?: string
        geo?: Geo
        createdAt?: Date
    }) {
        this.hostId = hostId
        this.address = address
        this.geo = geo
        this.createdAt = createdAt
    }

    readonly hostId?: string

    readonly address?: string

    readonly geo?: Geo

    readonly createdAt?: Date

    private static geoConverterToJson(geo: Geo): Record<string, unknown> {
        return {
            geohash: geo.geohash,
            geopoint: geo.geopoint
        }
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.hostId != undefined) {
            json[`hostId`] = this.hostId
        }
        if (this.address != undefined) {
            json[`address`] = this.address
        }
        if (this.geo != undefined) {
            json[`geo`] = UpdateHostLocation.geoConverterToJson(this.geo)
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteHostLocation {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the hostLocations collection for reading.
 */
export const readHostLocationCollectionReference = db
    .collection(`hostLocations`)
    .withConverter<ReadHostLocation>({
        fromFirestore: (ds: DocumentSnapshot): ReadHostLocation => {
            return ReadHostLocation.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(
                `toFirestore is not implemented for ReadHostLocation`
            )
        }
    })

/**
 * Provides a reference to a hostLocation document for reading.
 * @param hostLocationId - The ID of the hostLocation document to read.
 */
export const readHostLocationDocumentReference = ({
    hostLocationId
}: {
    hostLocationId: string
}): DocumentReference<ReadHostLocation> =>
    readHostLocationCollectionReference.doc(hostLocationId)

/**
 * Provides a reference to the hostLocations collection for creating.
 */
export const createHostLocationCollectionReference = db
    .collection(`hostLocations`)
    .withConverter<CreateHostLocation>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for CreateHostLocation`
            )
        },
        toFirestore: (obj: CreateHostLocation): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a hostLocation document for creating.
 * @param hostLocationId - The ID of the hostLocation document to read.
 */
export const createHostLocationDocumentReference = ({
    hostLocationId
}: {
    hostLocationId: string
}): DocumentReference<CreateHostLocation> =>
    createHostLocationCollectionReference.doc(hostLocationId)

/**
 * Provides a reference to the hostLocations collection for updating.
 */
export const updateHostLocationCollectionReference = db
    .collection(`hostLocations`)
    .withConverter<UpdateHostLocation>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for UpdateHostLocation`
            )
        },
        toFirestore: (obj: UpdateHostLocation): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a hostLocation document for updating.
 * @param hostLocationId - The ID of the hostLocation document to read.
 */
export const updateHostLocationDocumentReference = ({
    hostLocationId
}: {
    hostLocationId: string
}): DocumentReference<UpdateHostLocation> =>
    updateHostLocationCollectionReference.doc(hostLocationId)

/**
 * Provides a reference to the hostLocations collection for deleting.
 */
export const deleteHostLocationCollectionReference = db
    .collection(`hostLocations`)
    .withConverter<DeleteHostLocation>({
        fromFirestore: () => {
            throw new Error(
                `fromFirestore is not implemented for DeleteHostLocation`
            )
        },
        toFirestore: (): DocumentData => {
            throw new Error(
                `toFirestore is not implemented for DeleteHostLocation`
            )
        }
    })

/**
 * Provides a reference to a hostLocation document for deleting.
 * @param hostLocationId - The ID of the hostLocation document to read.
 */
export const deleteHostLocationDocumentReference = ({
    hostLocationId
}: {
    hostLocationId: string
}): DocumentReference<DeleteHostLocation> =>
    deleteHostLocationCollectionReference.doc(hostLocationId)

/**
 * Manages queries against the hostLocations collection.
 */
export class HostLocationQuery {
    /**
     * Fetches hostLocation documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (
            query: Query<ReadHostLocation>
        ) => Query<ReadHostLocation>
        compare?: (lhs: ReadHostLocation, rhs: ReadHostLocation) => number
    }): Promise<ReadHostLocation[]> {
        let query: Query<ReadHostLocation> = readHostLocationCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadHostLocation> = await query.get()
        let result = qs.docs.map(
            (qds: QueryDocumentSnapshot<ReadHostLocation>) => qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific hostLocation document.
     * @param hostLocationId - The ID of the hostLocation document to fetch.
     */
    async fetchDocument({
        hostLocationId
    }: {
        hostLocationId: string
    }): Promise<ReadHostLocation | undefined> {
        const ds = await readHostLocationDocumentReference({
            hostLocationId
        }).get()
        return ds.data()
    }

    /**
     * Adds a hostLocation document.
     * @param createHostLocation - The hostLocation details to add.
     */
    async add({
        createHostLocation
    }: {
        createHostLocation: CreateHostLocation
    }): Promise<DocumentReference<CreateHostLocation>> {
        return createHostLocationCollectionReference.add(createHostLocation)
    }

    /**
     * Sets a hostLocation document.
     * @param hostLocationId - The ID of the hostLocation document to set.
     * @param createHostLocation - The hostLocation details to set.
     * @param options - Options for the set operation.
     */
    async set({
        hostLocationId,
        createHostLocation,
        options
    }: {
        hostLocationId: string
        createHostLocation: CreateHostLocation
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createHostLocationDocumentReference({
                hostLocationId
            }).set(createHostLocation)
        } else {
            return createHostLocationDocumentReference({
                hostLocationId
            }).set(createHostLocation, options)
        }
    }

    /**
     * Updates a specific hostLocation document.
     * @param hostLocationId - The ID of the hostLocation document to update.
     * @param updateHostLocation - The details for updating the hostLocation.
     */
    async update({
        hostLocationId,
        updateHostLocation
    }: {
        hostLocationId: string
        updateHostLocation: UpdateHostLocation
    }): Promise<WriteResult> {
        return updateHostLocationDocumentReference({
            hostLocationId
        }).update(updateHostLocation.toJson())
    }

    /**
     * Deletes a specific hostLocation document.
     * @param hostLocationId - The ID of the hostLocation document to delete.
     */
    async delete({
        hostLocationId
    }: {
        hostLocationId: string
    }): Promise<WriteResult> {
        return deleteHostLocationDocumentReference({
            hostLocationId
        }).delete()
    }
}
