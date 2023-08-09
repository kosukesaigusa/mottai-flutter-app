export class ReadWorker {
    constructor(
        public readonly workerId: string,
        public readonly path: string,
        public readonly displayName: string,
        public readonly imageUrl: string,
        public readonly isHost: boolean,
        public readonly createdAt?: Date,
        public readonly updatedAt?: Date
    ) {}

    private static fromJson(json: Record<string, unknown>): ReadWorker {
        return new ReadWorker(
            json[`workerId`] as string,
            json[`path`] as string,
            (json[`displayName`] as string | undefined) ?? ``,
            (json[`imageUrl`] as string | undefined) ?? ``,
            (json[`isHost`] as boolean | undefined) ?? false,
            (
                json[`createdAt`] as FirebaseFirestore.Timestamp | undefined
            )?.toDate(),
            (
                json[`updatedAt`] as FirebaseFirestore.Timestamp | undefined
            )?.toDate()
        )
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
