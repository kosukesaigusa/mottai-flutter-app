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

export type AccessType =
    | `trainAvailable`
    | `busAvailable`
    | `parkingAvailable`
    | `walkableFromNearest`
    | `shuttleServiceAvailable`

export class ReadJob {
    constructor({
        jobId,
        path,
        hostId,
        imageUrl,
        title,
        place,
        content,
        belongings,
        reward,
        accessDescription,
        accessTypes,
        comment,
        createdAt,
        updatedAt
    }: {
        jobId: string
        path: string
        hostId: string
        imageUrl: string
        title: string
        place: string
        content: string
        belongings: string
        reward: string
        accessDescription: string
        accessTypes: Set<AccessType>
        comment: string
        createdAt?: Date
        updatedAt?: Date
    }) {
        this.jobId = jobId
        this.path = path
        this.hostId = hostId
        this.imageUrl = imageUrl
        this.title = title
        this.place = place
        this.content = content
        this.belongings = belongings
        this.reward = reward
        this.accessDescription = accessDescription
        this.accessTypes = accessTypes
        this.comment = comment
        this.createdAt = createdAt
        this.updatedAt = updatedAt
    }

    readonly jobId: string

    readonly path: string

    readonly hostId: string

    readonly imageUrl: string

    readonly title: string

    readonly place: string

    readonly content: string

    readonly belongings: string

    readonly reward: string

    readonly accessDescription: string

    readonly accessTypes: Set<AccessType>

    readonly comment: string

    readonly createdAt?: Date

    readonly updatedAt?: Date

    private static accessTypesConverterFromJson(
        accessTypes: unknown[] | undefined
    ): Set<AccessType> {
        return new Set((accessTypes ?? []).map((e) => e as AccessType))
    }

    private static fromJson(json: Record<string, unknown>): ReadJob {
        return new ReadJob({
            jobId: json[`jobId`] as string,
            path: json[`path`] as string,
            hostId: json[`hostId`] as string,
            imageUrl: (json[`imageUrl`] as string | undefined) ?? ``,
            title: (json[`title`] as string | undefined) ?? ``,
            place: (json[`place`] as string | undefined) ?? ``,
            content: (json[`content`] as string | undefined) ?? ``,
            belongings: (json[`belongings`] as string | undefined) ?? ``,
            reward: (json[`reward`] as string | undefined) ?? ``,
            accessDescription:
                (json[`accessDescription`] as string | undefined) ?? ``,
            accessTypes:
                json[`accessTypes`] == undefined
                    ? new Set()
                    : ReadJob.accessTypesConverterFromJson(
                          json[`accessTypes`] as unknown[]
                      ),
            comment: (json[`comment`] as string | undefined) ?? ``,
            createdAt: (json[`createdAt`] as Timestamp | undefined)?.toDate(),
            updatedAt: (json[`updatedAt`] as Timestamp | undefined)?.toDate()
        })
    }

    static fromDocumentSnapshot(ds: DocumentSnapshot): ReadJob {
        const data = ds.data()!
        const cleanedData: Record<string, unknown> = {}
        for (const [key, value] of Object.entries(data)) {
            cleanedData[key] = value === null ? undefined : value
        }
        return ReadJob.fromJson({
            ...cleanedData,
            jobId: ds.id,
            path: ds.ref.path
        })
    }
}

export class CreateJob {
    constructor({
        hostId,
        imageUrl,
        title,
        place,
        content,
        belongings,
        reward,
        accessDescription,
        accessTypes,
        comment
    }: {
        hostId: string
        imageUrl: string
        title: string
        place: string
        content: string
        belongings: string
        reward: string
        accessDescription: string
        accessTypes: Set<AccessType>
        comment: string
    }) {
        this.hostId = hostId
        this.imageUrl = imageUrl
        this.title = title
        this.place = place
        this.content = content
        this.belongings = belongings
        this.reward = reward
        this.accessDescription = accessDescription
        this.accessTypes = accessTypes
        this.comment = comment
    }

    readonly hostId: string

    readonly imageUrl: string

    readonly title: string

    readonly place: string

    readonly content: string

    readonly belongings: string

    readonly reward: string

    readonly accessDescription: string

    readonly accessTypes: Set<AccessType>

    readonly comment: string

    private static accessTypesConverterToJson(
        accessTypes: Set<AccessType>
    ): string[] {
        return [...accessTypes]
    }

    toJson(): Record<string, unknown> {
        return {
            hostId: this.hostId,
            imageUrl: this.imageUrl,
            title: this.title,
            place: this.place,
            content: this.content,
            belongings: this.belongings,
            reward: this.reward,
            accessDescription: this.accessDescription,
            accessTypes: CreateJob.accessTypesConverterToJson(this.accessTypes),
            comment: this.comment,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp()
        }
    }
}

export class UpdateJob {
    constructor({
        hostId,
        imageUrl,
        title,
        place,
        content,
        belongings,
        reward,
        accessDescription,
        accessTypes,
        comment,
        createdAt
    }: {
        hostId?: string
        imageUrl?: string
        title?: string
        place?: string
        content?: string
        belongings?: string
        reward?: string
        accessDescription?: string
        accessTypes?: Set<AccessType>
        comment?: string
        createdAt?: Date
    }) {
        this.hostId = hostId
        this.imageUrl = imageUrl
        this.title = title
        this.place = place
        this.content = content
        this.belongings = belongings
        this.reward = reward
        this.accessDescription = accessDescription
        this.accessTypes = accessTypes
        this.comment = comment
        this.createdAt = createdAt
    }

    readonly hostId?: string

    readonly imageUrl?: string

    readonly title?: string

    readonly place?: string

    readonly content?: string

    readonly belongings?: string

    readonly reward?: string

    readonly accessDescription?: string

    readonly accessTypes?: Set<AccessType>

    readonly comment?: string

    readonly createdAt?: Date

    private static accessTypesConverterToJson(
        accessTypes: Set<AccessType>
    ): string[] {
        return [...accessTypes]
    }

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    toJson(): Record<string, any> {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const json: Record<string, any> = {}
        if (this.hostId != undefined) {
            json[`hostId`] = this.hostId
        }
        if (this.imageUrl != undefined) {
            json[`imageUrl`] = this.imageUrl
        }
        if (this.title != undefined) {
            json[`title`] = this.title
        }
        if (this.place != undefined) {
            json[`place`] = this.place
        }
        if (this.content != undefined) {
            json[`content`] = this.content
        }
        if (this.belongings != undefined) {
            json[`belongings`] = this.belongings
        }
        if (this.reward != undefined) {
            json[`reward`] = this.reward
        }
        if (this.accessDescription != undefined) {
            json[`accessDescription`] = this.accessDescription
        }
        if (this.accessTypes != undefined) {
            json[`accessTypes`] = UpdateJob.accessTypesConverterToJson(
                this.accessTypes
            )
        }
        if (this.comment != undefined) {
            json[`comment`] = this.comment
        }
        if (this.createdAt != undefined) {
            json[`createdAt`] = this.createdAt
        }
        json[`updatedAt`] = FieldValue.serverTimestamp()
        return json
    }
}

export class DeleteJob {}

/**
 * A Cloud Firestore object which ignores `undefined` properties.
 */
const db = admin.firestore()
db.settings({ ignoreUndefinedProperties: true })

/**
 * Provides a reference to the jobs collection for reading.
 */
export const readJobCollectionReference = db
    .collection(`jobs`)
    .withConverter<ReadJob>({
        fromFirestore: (ds: DocumentSnapshot): ReadJob => {
            return ReadJob.fromDocumentSnapshot(ds)
        },
        toFirestore: () => {
            throw new Error(`toFirestore is not implemented for ReadJob`)
        }
    })

/**
 * Provides a reference to a job document for reading.
 * @param jobId - The ID of the job document to read.
 */
export const readJobDocumentReference = ({
    jobId
}: {
    jobId: string
}): DocumentReference<ReadJob> => readJobCollectionReference.doc(jobId)

/**
 * Provides a reference to the jobs collection for creating.
 */
export const createJobCollectionReference = db
    .collection(`jobs`)
    .withConverter<CreateJob>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for CreateJob`)
        },
        toFirestore: (obj: CreateJob): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a job document for creating.
 * @param jobId - The ID of the job document to read.
 */
export const createJobDocumentReference = ({
    jobId
}: {
    jobId: string
}): DocumentReference<CreateJob> => createJobCollectionReference.doc(jobId)

/**
 * Provides a reference to the jobs collection for updating.
 */
export const updateJobCollectionReference = db
    .collection(`jobs`)
    .withConverter<UpdateJob>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for UpdateJob`)
        },
        toFirestore: (obj: UpdateJob): DocumentData => {
            return obj.toJson()
        }
    })

/**
 * Provides a reference to a job document for updating.
 * @param jobId - The ID of the job document to read.
 */
export const updateJobDocumentReference = ({
    jobId
}: {
    jobId: string
}): DocumentReference<UpdateJob> => updateJobCollectionReference.doc(jobId)

/**
 * Provides a reference to the jobs collection for deleting.
 */
export const deleteJobCollectionReference = db
    .collection(`jobs`)
    .withConverter<DeleteJob>({
        fromFirestore: () => {
            throw new Error(`fromFirestore is not implemented for DeleteJob`)
        },
        toFirestore: (): DocumentData => {
            throw new Error(`toFirestore is not implemented for DeleteJob`)
        }
    })

/**
 * Provides a reference to a job document for deleting.
 * @param jobId - The ID of the job document to read.
 */
export const deleteJobDocumentReference = ({
    jobId
}: {
    jobId: string
}): DocumentReference<DeleteJob> => deleteJobCollectionReference.doc(jobId)

/**
 * Manages queries against the jobs collection.
 */
export class JobQuery {
    /**
     * Fetches job documents.
     * @param queryBuilder - Function to modify the query.
     * @param compare - Function to sort the results.
     */
    async fetchDocuments({
        queryBuilder,
        compare
    }: {
        queryBuilder?: (query: Query<ReadJob>) => Query<ReadJob>
        compare?: (lhs: ReadJob, rhs: ReadJob) => number
    }): Promise<ReadJob[]> {
        let query: Query<ReadJob> = readJobCollectionReference
        if (queryBuilder != undefined) {
            query = queryBuilder(query)
        }
        const qs: QuerySnapshot<ReadJob> = await query.get()
        let result = qs.docs.map((qds: QueryDocumentSnapshot<ReadJob>) =>
            qds.data()
        )
        if (compare != undefined) {
            result = result.sort(compare)
        }
        return result
    }

    /**
     * Fetches a specific job document.
     * @param jobId - The ID of the job document to fetch.
     */
    async fetchDocument({
        jobId
    }: {
        jobId: string
    }): Promise<ReadJob | undefined> {
        const ds = await readJobDocumentReference({
            jobId
        }).get()
        return ds.data()
    }

    /**
     * Adds a job document.
     * @param createJob - The job details to add.
     */
    async add({
        createJob
    }: {
        createJob: CreateJob
    }): Promise<DocumentReference<CreateJob>> {
        return createJobCollectionReference.add(createJob)
    }

    /**
     * Sets a job document.
     * @param jobId - The ID of the job document to set.
     * @param createJob - The job details to set.
     * @param options - Options for the set operation.
     */
    async set({
        jobId,
        createJob,
        options
    }: {
        jobId: string
        createJob: CreateJob
        options?: SetOptions
    }): Promise<WriteResult> {
        if (options == undefined) {
            return createJobDocumentReference({
                jobId
            }).set(createJob)
        } else {
            return createJobDocumentReference({
                jobId
            }).set(createJob, options)
        }
    }

    /**
     * Updates a specific job document.
     * @param jobId - The ID of the job document to update.
     * @param updateJob - The details for updating the job.
     */
    async update({
        jobId,
        updateJob
    }: {
        jobId: string
        updateJob: UpdateJob
    }): Promise<WriteResult> {
        return updateJobDocumentReference({
            jobId
        }).update(updateJob.toJson())
    }

    /**
     * Deletes a specific job document.
     * @param jobId - The ID of the job document to delete.
     */
    async delete({ jobId }: { jobId: string }): Promise<WriteResult> {
        return deleteJobDocumentReference({
            jobId
        }).delete()
    }
}
