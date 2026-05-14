-- CreateTable
CREATE TABLE "album" (
    "album_id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "release_year" INTEGER,
    "artist_id" INTEGER NOT NULL,

    CONSTRAINT "album_pkey" PRIMARY KEY ("album_id")
);

-- CreateTable
CREATE TABLE "artist" (
    "artist_id" SERIAL NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "country" VARCHAR(100),

    CONSTRAINT "artist_pkey" PRIMARY KEY ("artist_id")
);

-- CreateTable
CREATE TABLE "customer" (
    "customer_id" SERIAL NOT NULL,
    "full_name" VARCHAR(255) NOT NULL,
    "email" VARCHAR(150) NOT NULL,

    CONSTRAINT "customer_pkey" PRIMARY KEY ("customer_id")
);

-- CreateTable
CREATE TABLE "genre" (
    "genre_id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,

    CONSTRAINT "genre_pkey" PRIMARY KEY ("genre_id")
);

-- CreateTable
CREATE TABLE "rental" (
    "rental_id" SERIAL NOT NULL,
    "start_date" DATE DEFAULT CURRENT_DATE,
    "end_date" DATE NOT NULL,
    "customer_id" INTEGER NOT NULL,

    CONSTRAINT "rental_pkey" PRIMARY KEY ("rental_id")
);

-- CreateTable
CREATE TABLE "rental_item" (
    "rental_id" INTEGER NOT NULL,
    "track_id" INTEGER NOT NULL,

    CONSTRAINT "rental_item_pkey" PRIMARY KEY ("rental_id","track_id")
);

-- CreateTable
CREATE TABLE "track" (
    "track_id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "duration" DOUBLE PRECISION NOT NULL,
    "daily_rate" DECIMAL(10,2) NOT NULL,
    "album_id" INTEGER,
    "genre_id" INTEGER,

    CONSTRAINT "track_pkey" PRIMARY KEY ("track_id")
);

-- CreateTable
CREATE TABLE "review" (
    "id" SERIAL NOT NULL,
    "rating" INTEGER NOT NULL DEFAULT 5,
    "comment" TEXT,
    "trackId" INTEGER NOT NULL,

    CONSTRAINT "review_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "customer_email_key" ON "customer"("email");

-- CreateIndex
CREATE UNIQUE INDEX "genre_name_key" ON "genre"("name");

-- AddForeignKey
ALTER TABLE "album" ADD CONSTRAINT "album_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artist"("artist_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "rental" ADD CONSTRAINT "rental_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "customer"("customer_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "rental_item" ADD CONSTRAINT "rental_item_rental_id_fkey" FOREIGN KEY ("rental_id") REFERENCES "rental"("rental_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "rental_item" ADD CONSTRAINT "rental_item_track_id_fkey" FOREIGN KEY ("track_id") REFERENCES "track"("track_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "track" ADD CONSTRAINT "track_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "album"("album_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "track" ADD CONSTRAINT "track_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genre"("genre_id") ON DELETE SET NULL ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "review" ADD CONSTRAINT "review_trackId_fkey" FOREIGN KEY ("trackId") REFERENCES "track"("track_id") ON DELETE RESTRICT ON UPDATE CASCADE;
