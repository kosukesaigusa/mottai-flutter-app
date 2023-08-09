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
