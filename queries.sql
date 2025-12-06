-- select bl.id, bl.status, b.id, b.title, l.address, r.email
-- from book_loans bl
--          left join books b on b.id = bl.book_id
--          left join libraries l on l.id = bl.library_id
--          left join readers r on r.id = bl.reader_id


-- select b.title, l.address, bl.status, concat(r.first_name, ' ',  r.last_name)
-- from books b
--          left join libraries l on l.id = b.library_id
--          left join book_loans bl on bl.book_id = b.id
--          left join readers r on r.id = bl.reader_id

-- select b.title,
--        l.address,
--        bl.status,
--        concat(r.first_name, ' ', r.last_name) as reader,
--        concat(a.first_name, ' ', a.last_name) as author
-- from books b
--          join libraries l on l.id = b.library_id
--          join book_loans bl on bl.book_id = b.id
--          join readers r on r.id = bl.reader_id
--          join book_authors ba on ba.book_id = b.id
--          join authors a on a.id = ba.author_id

-- select b.library_id, count(*) as book_count
-- from books b
-- group by b.library_id;

select l.id, count(*) as book_count
from books b
         left join libraries l on l.id = b.library_id
group by l.id

