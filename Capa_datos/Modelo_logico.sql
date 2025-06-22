
CREATE TABLE detalle_fase
(
  id_detalle_fase int          NOT NULL GENERATED ALWAYS AS IDENTITY,
  id_tipo_dato    int          NOT NULL,
  valor           numeric(5,2) NOT NULL,
  id_fase         int          NOT NULL,
  id_lote_leche   int          NOT NULL,
  fecha           timestamptz  NOT NULL,
  PRIMARY KEY (id_detalle_fase),
  CHECK (valor >= 0 AND valor <= 100),
  CHECK (fecha <= now())
);

CREATE TABLE detalle_lata
(
  id_detalle_lata int         NOT NULL GENERATED ALWAYS AS IDENTITY,
  muestra         boolean     NOT NULL,
  fec_etiquetado  timestamptz NOT NULL,
  url_etiqueta    text        NOT NULL UNIQUE,
  fec_vencimiento timestamptz NOT NULL,
  id_lata         int         NOT NULL,
  PRIMARY KEY (id_detalle_lata),
  CHECK (fec_etiquetado <= now()),
  CHECK (fec_vencimiento > now())
);

COMMENT ON COLUMN detalle_lata.muestra IS 'agujereada';

COMMENT ON COLUMN detalle_lata.url_etiqueta IS 'qr';

CREATE TABLE disponibilidad
(
  id_fase      int NOT NULL,
  id_tipo_dato int NOT NULL,
  PRIMARY KEY (id_fase, id_tipo_dato)
);

CREATE TABLE ejecucion_fase
(
  id_fase       int         NOT NULL,
  id_lote_leche int         NOT NULL,
  fec_inicio    timestamptz NOT NULL,
  fec_fin       timestamptz NOT NULL,
  PRIMARY KEY (id_fase, id_lote_leche),
  CHECK (fec_fin <= now()),
  CHECK (fec_inicio <= fec_fin)
);

CREATE TABLE fase
(
  id_fase     int          NOT NULL GENERATED ALWAYS AS IDENTITY,
  nombre      varchar(30)  NOT NULL UNIQUE,
  estado      boolean      NOT NULL DEFAULT 1,
  descripcion varchar(250) NOT NULL,
  PRIMARY KEY (id_fase)
);

COMMENT ON COLUMN fase.estado IS '0: inactiva, 1:activa';

CREATE TABLE lata
(
  id_lata       int         NOT NULL GENERATED ALWAYS AS IDENTITY,
  id_lote_leche int         NOT NULL,
  fec_enlatado  timestamptz NOT NULL,
  PRIMARY KEY (id_lata),
  CHECK (fec_enlatado <= now())
);

CREATE TABLE lote_leche
(
  id_lote_leche   int          NOT NULL GENERATED ALWAYS AS IDENTITY,
  grasa           numeric(3,2) NOT NULL,
  microorganismos numeric(3,2) NOT NULL,
  vitamina_a      numeric(3,2) NOT NULL,
  vitamina_b      numeric(3,2) NOT NULL,
  temperatura     numeric(5,2) NOT NULL,
  id_productor    int          NOT NULL,
  PRIMARY KEY (id_lote_leche),
  CHECK (grasa >= 0 AND grasa <= 100),
  CHECK (microorganismos >= 0 AND microorganismos <= 100),
  CHECK (vitamina_a >= 0 AND vitamina_a <= 100),
  CHECK (vitamina_b >= 0 AND vitamina_b <= 100),
  CHECK (temperatura >= 0 AND temperatura <= 100)
);

COMMENT ON COLUMN lote_leche.grasa IS 'porcentaje';

COMMENT ON COLUMN lote_leche.microorganismos IS 'porcentaje';

COMMENT ON COLUMN lote_leche.vitamina_a IS 'porcentaje';

COMMENT ON COLUMN lote_leche.vitamina_b IS 'porcentaje';

COMMENT ON COLUMN lote_leche.temperatura IS 'inicial';

CREATE TABLE productor
(
  id_productor int         NOT NULL GENERATED ALWAYS AS IDENTITY,
  nombre       varchar(20) NOT NULL UNIQUE,
  ruc          varchar(11) NOT NULL UNIQUE,
  telefono     varchar(9)  NOT NULL UNIQUE,
  PRIMARY KEY (id_productor)
);

CREATE TABLE tipo_dato
(
  id_tipo_dato  int         NOT NULL GENERATED ALWAYS AS IDENTITY,
  nombre        varchar(20) NOT NULL,
  unidad_medida varchar(10) NOT NULL,
  PRIMARY KEY (id_tipo_dato)
);

ALTER TABLE lote_leche
  ADD CONSTRAINT FK_productor_TO_lote_leche
    FOREIGN KEY (id_productor)
    REFERENCES productor (id_productor);

ALTER TABLE ejecucion_fase
  ADD CONSTRAINT FK_fase_TO_ejecucion_fase
    FOREIGN KEY (id_fase)
    REFERENCES fase (id_fase);

ALTER TABLE ejecucion_fase
  ADD CONSTRAINT FK_lote_leche_TO_ejecucion_fase
    FOREIGN KEY (id_lote_leche)
    REFERENCES lote_leche (id_lote_leche);

ALTER TABLE lata
  ADD CONSTRAINT FK_lote_leche_TO_lata
    FOREIGN KEY (id_lote_leche)
    REFERENCES lote_leche (id_lote_leche);

ALTER TABLE detalle_fase
  ADD CONSTRAINT FK_tipo_dato_TO_detalle_fase
    FOREIGN KEY (id_tipo_dato)
    REFERENCES tipo_dato (id_tipo_dato);

ALTER TABLE detalle_fase
  ADD CONSTRAINT FK_ejecucion_fase_TO_detalle_fase
    FOREIGN KEY (id_fase, id_lote_leche)
    REFERENCES ejecucion_fase (id_fase, id_lote_leche);

ALTER TABLE disponibilidad
  ADD CONSTRAINT FK_fase_TO_disponibilidad
    FOREIGN KEY (id_fase)
    REFERENCES fase (id_fase);

ALTER TABLE disponibilidad
  ADD CONSTRAINT FK_tipo_dato_TO_disponibilidad
    FOREIGN KEY (id_tipo_dato)
    REFERENCES tipo_dato (id_tipo_dato);

ALTER TABLE detalle_lata
  ADD CONSTRAINT FK_lata_TO_detalle_lata
    FOREIGN KEY (id_lata)
    REFERENCES lata (id_lata);
