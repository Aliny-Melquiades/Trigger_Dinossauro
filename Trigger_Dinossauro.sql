--Criação das Tabelas
create table dinossauros (
	id serial primary key,
	nome varchar not null,
	toneladas integer not null,
	ano_descoberta integer not null,
	fk_grupo integer,
	fk_era integer,
	fk_regiao integer,
	fk_descobridor integer,
	inicio integer,
	fim integer,
	foreign key (fk_grupo) references grupos(id),
	foreign key (fk_era) references eras(id),
	foreign key (fk_regiao) references regioes(id),
	foreign key (fk_descobridor) references descobridores(id)	
)

create table regioes (
	id serial primary key,
	nome varchar not null
)


create table grupos (
	id serial primary key,
	nome varchar not null
)

create table eras (
	id serial primary key,
	nome varchar not null,
	inicio_era int not null,
	fim_era int not null	
)

create table descobridores (
	id serial primary key,
	nome varchar not null
)

--Inserção Dos Dados
insert into regioes (nome) values ('Mongólia'), ('Canadá'), ('Tanzânia'), ('China'), ('America do Norte'), ('USA');
select * from regioes

insert into grupos (nome) values ('Anquilossauros'), ('Ceratopsídeos'), ('Estegossauros'), ('Terápodes');
select * from grupos

insert into eras (nome, inicio_era, fim_era) values ('Triássico', 251, 200), ('Jurássico', 200, 145), ('Cretáceo', 145, 65);
select * from eras

insert into descobridores (nome) values ('Maryanska'), ('John Bell Hatcher'), ('Cinetistas Alemãs'), ('Museu Americano de História Natural'), ('Othniel Charles Marsh'), ('Barnum Brown');
select * from descobridores

--Criação Da função
CREATE OR REPLACE FUNCTION verificar_era()
RETURNS TRIGGER AS $BODY$
DECLARE
    era_inicio_era INT := 0; 
    era_fim_era INT := 0;    
BEGIN
    SELECT inicio_era, fim_era
    INTO era_inicio_era, era_fim_era
    FROM eras
    WHERE id = NEW.fk_era;    
    IF (NEW.inicio < era_inicio_era OR NEW.fim > era_fim_era) THEN
        RAISE EXCEPTION 'O período informado (% - %) não está dentro da duração permitida para a era %.', 
                        NEW.inicio, NEW.fim, NEW.fk_era;
    END IF;
				RAISE NOTICE 'Validação Permitida';   
    RETURN NEW;
END;
$BODY$ 
	LANGUAGE plpgsql VOLATILE;

-- Criação da trigger
CREATE TRIGGER trigger_verificar_era
AFTER INSERT 
ON dinossauros
FOR EACH ROW EXECUTE PROCEDURE verificar_era();


insert into dinossauros(nome, toneladas, ano_descoberta, fk_grupo, fk_era, fk_regiao, fk_descobridor, inicio, fim) values ('Kentrossauro', 2, 1909, 3, 2, 3, 3, 200, 145) -- Validação Permitida
insert into dinossauros(nome, toneladas, ano_descoberta, fk_grupo, fk_era, fk_regiao, fk_descobridor, inicio, fim) values	('Saichania', 4, 1977, 1, 3, 1, 1, 145, 66) --Validação Nâo Permitida
