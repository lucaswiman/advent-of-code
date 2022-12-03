-- sqlite
create table rucksacks(
    input TEXT,
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    duplicated_character TEXT
);
.mode csv
.import 'input' rucksacks

create table rucksack_compartment_item(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    compartment_number INTEGER,
    c TEXT,
    string_index INTEGER,
    rucksack_id INTEGER,
    FOREIGN KEY(rucksack_id) REFERENCES rucksacks(id)
);

INSERT INTO rucksack_compartment_item(rucksack_id, c, string_index, compartment_number)
select rucksacks.id as rucksack_id, substr(input, idx, 1) as c, idx, (2*(idx-1)) / length(input) as compartment_number
from rucksacks join (
    WITH RECURSIVE
    cnt(idx) AS (
        SELECT 1
        UNION ALL
        SELECT idx+1 FROM cnt
        LIMIT (select max(length(input)) from rucksacks)
    )
    SELECT idx FROM cnt
) str_indexes
where idx <= length(input)
;

;

UPDATE rucksacks
set duplicated_character=c
FROM (
    select distinct cpt1.c AS c, cpt1.rucksack_id AS rucksack_id
    from rucksack_compartment_item cpt1
    join rucksack_compartment_item cpt2 on cpt1.rucksack_id=cpt2.rucksack_id and cpt1.c=cpt2.c
    where cpt1.compartment_number < cpt2.compartment_number
) duplicated_chars
 WHERE rucksacks.id=duplicated_chars.rucksack_id;


create table priorities(
    c TEXT,
    priority INTEGER
);
INSERT INTO priorities(c, priority)
SELECT char(unicode('a') + i) as c, i+1 as priority
FROM (
    WITH RECURSIVE
    cnt(idx) AS (
        SELECT 0
        UNION ALL
        SELECT idx+1 FROM cnt
        LIMIT 26
    )
    SELECT idx as i FROM cnt
);
INSERT INTO priorities(c, priority)
SELECT char(unicode('A') + i) as c, i+1+26 as priority
FROM (
    WITH RECURSIVE
    cnt(idx) AS (
        SELECT 0
        UNION ALL
        SELECT idx+1 FROM cnt
        LIMIT 26
    )
    SELECT idx as i FROM cnt
);

-- Part 1 solution:
select sum(priority) as part1_solution from priorities join rucksacks on duplicated_character=c;


-- Part 2
select sum(priorities.priority) from priorities join (
    select distinct rci1.rucksack_id, rci2.rucksack_id, rci3.rucksack_id, rci1.c as c
    from rucksack_compartment_item rci1
    join rucksack_compartment_item rci2 on (rci1.rucksack_id-1) / 3 == (rci2.rucksack_id-1) / 3 and rci1.c = rci2.c
    join rucksack_compartment_item rci3 on (rci1.rucksack_id-1) / 3 == (rci3.rucksack_id-1) / 3 and rci1.c = rci3.c
    where rci1.rucksack_id < rci2.rucksack_id and rci2.rucksack_id < rci3.rucksack_id
) badges on badges.c=priorities.c
;