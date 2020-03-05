import itertools
from collections import namedtuple
from lxml.builder import E

Entity = namedtuple('Entity', ['name', 'fields'])
Field = namedtuple('Field', ['name', 'column'])
MultiField = namedtuple('MultiField', ['name', 'column'])


class Schema(object):

    def __init__(self, entities):
        self.entities = entities
        self.entities_by_id = dict((e.name, e) for e in entities)

    def __getitem__(self, name):
        return self.entities_by_id[name]


class Entity(object):

    def __init__(self, name, fields):
        self.name = name
        self.fields = fields

    def iter_single_fields(self, name=None):
        for field in self.fields:
            if isinstance(field, Field):
                if name is not None and field.name != name:
                    continue
                yield field

    def iter_multi_fields(self, name=None):
        for field in self.fields:
            if isinstance(field, MultiField):
                if name is not None and field.name != name:
                    continue
                yield field


class Column(object):

    def __init__(self, name, foreign=None):
        self.name = name
        self.foreign = foreign


class ForeignColumn(Column):

    def __init__(self, table, name, foreign=None, null=False, backref=None):
        super(ForeignColumn, self).__init__(name, foreign=foreign)
        self.table = table
        self.null = null
        self.backref = backref


schema = Schema([
    Entity('artist', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('name', Column('name')),
        Field('sort_name', Column('sort_name')),
        Field('area', Column('area', ForeignColumn('area', 'name', null=True))),
        Field('gender', Column('gender', ForeignColumn('gender', 'name', null=True))),
        Field('type', Column('type', ForeignColumn('artist_type', 'name', null=True))),
        MultiField('mbid', ForeignColumn('artist_gid_redirect', 'gid', backref='new_id')),
        MultiField('ipi', ForeignColumn('artist_ipi', 'ipi')),
        MultiField('isni', ForeignColumn('artist_isni', 'isni')),
        MultiField('alias', ForeignColumn('artist_alias', 'name')),
    ]),
    Entity('label', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('code', Column('label_code')),
        Field('name', Column('name')),
        Field('sort_name', Column('sort_name')),
        Field('area', Column('area', ForeignColumn('area', 'name', null=True))),
        Field('type', Column('type', ForeignColumn('label_type', 'name', null=True))),
        MultiField('mbid', ForeignColumn('label_gid_redirect', 'gid', backref='new_id')),
        MultiField('ipi', ForeignColumn('label_ipi', 'ipi')),
        MultiField('isni', ForeignColumn('label_isni', 'isni')),
        MultiField('alias', ForeignColumn('label_alias', 'name')),
    ]),
    Entity('work', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('name', Column('name')),
        Field('type', Column('type')),
        MultiField('mbid', ForeignColumn('work_gid_redirect', 'gid', backref='new_id')),
        MultiField('iswc', ForeignColumn('iswc', 'iswc')),
        MultiField('alias', ForeignColumn('work_alias', 'name')),
    ]),
    Entity('release_group', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('name', Column('name')),
        Field('type', Column('type', ForeignColumn('release_group_primary_type', 'name', null=True))),
        MultiField('mbid', ForeignColumn('release_group_gid_redirect', 'gid', backref='new_id')),
        MultiField('type',
            ForeignColumn('release_group_secondary_type_join', 'secondary_type',
                ForeignColumn('release_group_secondary_type', 'name'))),
        Field('artist', Column('artist_credit', ForeignColumn('artist_credit', 'name'))),
        MultiField('alias', ForeignColumn('release', 'name')),
    ]),
    Entity('release', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('barcode', Column('barcode')),
        Field('name', Column('name')),
        Field('status', Column('status', ForeignColumn('release_status', 'name', null=True))),
        Field('type', Column('release_group', ForeignColumn('release_group', 'type', ForeignColumn('release_group_primary_type', 'name', null=True)))),
        Field('artist', Column('artist_credit', ForeignColumn('artist_credit', 'name'))),
        MultiField('country', ForeignColumn('release_country', 'country', ForeignColumn('area', 'name', null=True))),
        MultiField('country', ForeignColumn('release_country', 'country', ForeignColumn('iso_3166_1', 'code', null=True, backref='area'))),
        MultiField('mbid', ForeignColumn('release_gid_redirect', 'gid', backref='new_id')),
        MultiField('catno', ForeignColumn('release_label', 'catalog_number')),
        MultiField('label', ForeignColumn('release_label', 'label', ForeignColumn('label', 'name'))),
        Field('alias', Column('release_group', ForeignColumn('release_group', 'name'))),
    ]),
    Entity('recording', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('name', Column('name')),
        Field('artist', Column('artist_credit', ForeignColumn('artist_credit', 'name'))),
        MultiField('mbid', ForeignColumn('recording_gid_redirect', 'gid', backref='new_id')),
        MultiField('alias', ForeignColumn('track', 'name')),
    ]),
    Entity('place', [
        Field('mbid', Column('gid')),
        Field('disambiguation', Column('comment')),
        Field('name', Column('name')),
        Field('area', Column('area', ForeignColumn('area', 'name', null=True))),
        Field('type', Column('type', ForeignColumn('place_type', 'name', null=True))),
        MultiField('mbid', ForeignColumn('place_gid_redirect', 'gid', backref='new_id')),
        MultiField('alias', ForeignColumn('place_alias', 'name')),
    ]),
])


SQL_SELECT_TPL = "SELECT\n%(columns)s\nFROM\n%(joins)s\nORDER BY %(sort_column)s"


SQL_TRIGGER = """
CREATE OR REPLACE FUNCTION mbslave_solr_%(op1)s_%(table)s() RETURNS trigger AS $$
BEGIN
    %(code)s
    RETURN NULL;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS mbslave_solr_tr_%(op1)s_%(table)s ON musicbrainz.%(table)s;
CREATE TRIGGER mbslave_solr_tr_%(op1)s_%(table)s AFTER %(op2)s ON musicbrainz.%(table)s FOR EACH ROW EXECUTE PROCEDURE mbslave_solr_%(op1)s_%(table)s();
"""


def distinct_values(columns):
    return ' OR\n       '.join('OLD.%(c)s IS DISTINCT FROM NEW.%(c)s' % dict(c=c)
                               for c in columns)


def generate_trigger_update(path):
    condition = None
    for table, column, pk in path[1:]:
        if not condition:
            condition = 'FROM musicbrainz.%s WHERE %s = NEW.%s' % (table, column, pk)
        else:
            condition = 'FROM musicbrainz.%s WHERE %s IN (SELECT %s %s)' % (table, column, pk, condition)
    return path[0][0], path[0][1], condition


def generate_triggers():
    ins_del_deps = {}
    deps = {}
    for entity in schema.entities:
        for field in entity.iter_single_fields():
            column = field.column
            path = [(entity.name, column.name, 'id')]
            while column.foreign:
                column = column.foreign
                path.insert(0, (column.table, column.name, 'id'))
            for i in range(0, len(path)):
                table, column, values = generate_trigger_update(path[i:])
                deps.setdefault(table, {}).setdefault((entity.name, 'NEW', 'id', values), []).append(column)

        ins_del_deps.setdefault(entity.name, set()).add((entity.name, 'id'))

        for field in entity.iter_multi_fields():
            column = field.column
            backref = field.column.backref or entity.name
            path = []
            while column:
                path.insert(0, (column.table, column.name, column.foreign.backref if (column.foreign and column.foreign.backref) else 'id'))
                column = column.foreign
            for i in range(0, len(path)):
                table, column, values = generate_trigger_update(path[i:])
                deps.setdefault(table, {}).setdefault((entity.name, 'NEW', backref, values), []).append(column)

            # Changed parent row
            deps.setdefault(field.column.table, {}).setdefault((entity.name, 'NEW', backref, None), []).append(backref)
            deps.setdefault(field.column.table, {}).setdefault((entity.name, 'OLD', backref, None), []).append(backref)

            # Inserted or deleted new child row
            ins_del_deps.setdefault(field.column.table, set()).add((entity.name, backref))

    for table, kinds in sorted(ins_del_deps.items()):
        sections = []
        for kind, pk in kinds:
            sections.append("INSERT INTO mbslave.mbslave_solr_queue (entity_type, entity_id) VALUES ('%s', NEW.%s);" % (kind, pk))
        code = '\n    '.join(sections)
        yield SQL_TRIGGER % dict(table=table, code=code, op1='ins', op2='INSERT')

    for table, kinds in sorted(ins_del_deps.items()):
        sections = []
        for kind, pk in kinds:
            sections.append("INSERT INTO mbslave.mbslave_solr_queue (entity_type, entity_id) VALUES ('%s', OLD.%s);" % (kind, pk))
        code = '\n    '.join(sections)
        yield SQL_TRIGGER % dict(table=table, code=code, op1='del', op2='DELETE')

    for table, fields in sorted(deps.items()):
        sections = []
        for columns in set(map(tuple, fields.values())):
            inserts = []
            for (kind, ver, pk, values), c in fields.items():
                if columns != tuple(c):
                    continue
                if not values:
                    values = "VALUES ('%s', %s.%s)" % (kind, ver, pk)
                else:
                    values = "SELECT '%s', %s %s" % (kind, pk, values)
                inserts.append("INSERT INTO mbslave.mbslave_solr_queue (entity_type, entity_id) %s;" % values)
            sections.append("IF %s\n    THEN\n        %s\n    END IF;" % (distinct_values(columns), "\n        ".join(inserts)))
        code = '\n    '.join(sections)
        yield SQL_TRIGGER % dict(table=table, code=code, op1='upd', op2='UPDATE')



def generate_iter_query(columns, joins, ids=()):
    id_column = columns[0]
    tpl = ["SELECT", "%(columns)s", "FROM", "%(joins)s"]
    if ids:
        tpl.append("WHERE %(id_column)s IN (%(ids)s)")
    tpl.append("ORDER BY %(id_column)s")
    sql_columns = ',\n'.join('  ' + i for i in columns)
    sql_joins = '\n'.join('  ' + i for i in joins)
    sql = "\n".join(tpl) % dict(columns=sql_columns, joins=sql_joins,
                                id_column=id_column, ids=placeholders(ids))
    return sql


def iter_main(db, kind, ids=()):
    entity = schema[kind]
    joins = [kind]
    tables = set([kind])
    columns = ['%s.id' % (kind,)]
    names = []
    for field in entity.iter_single_fields():
        table = kind
        column = field.column
        while column.foreign is not None:
            foreign_table = table + '__' + column.name + '__' + column.foreign.table
            if foreign_table not in tables:
                join = 'LEFT JOIN' if column.foreign.null else 'JOIN'
                joins.append('%(join)s %(parent)s AS %(label)s ON %(label)s.id = %(child)s.%(child_column)s' % dict(
                    join=join, parent=column.foreign.table, child=table, child_column=column.name, label=foreign_table))
                tables.add(foreign_table)
            table = foreign_table
            column = column.foreign
        columns.append('%s.%s' % (table, column.name))
        names.append(field.name)

    query = generate_iter_query(columns, joins, ids)
    cursor = db.cursor('cursor_' + kind)
    cursor.itersize = 100 * 1000
    cursor.execute(query, ids)
    for row in cursor:
        id = row[0]
        fields = [E.field(kind, name='kind'), E.field('%s:%s' % (kind, id), name='id')]
        for name, value in zip(names, row[1:]):
            if not value:
                continue
            if isinstance(value, str):
                value = value.decode('utf8')
            elif not isinstance(value, unicode):
                value = unicode(value)
            try:
                fields.append(E.field(value, name=name))
            except ValueError:
                continue # XXX
        yield id, fields


def iter_sub(db, kind, subtable, ids=()):
    entity = schema[kind]
    joins = []
    tables = set()
    columns = []
    names = []
    for field in entity.iter_multi_fields():
        if field.column.table != subtable:
            continue
        last_column = column = field.column
        table = column.table
        while True:
            if last_column is column:
                if table not in tables:
                    joins.append(table)
                    tables.add(table)
                    columns.append('%s.%s' % (table, column.backref or kind))
            else:
                foreign_table = table + '__' + last_column.name + '__' + column.table
                if foreign_table not in tables:
                    join = 'LEFT JOIN' if column.null else 'JOIN'
                    pk = column.backref or 'id'
                    joins.append('%(join)s %(parent)s AS %(label)s ON %(label)s.%(pk)s = %(child)s.%(child_column)s' % dict(
                        join=join, parent=column.table, child=table, child_column=last_column.name, label=foreign_table, pk=pk))
                    tables.add(foreign_table)
                table = foreign_table
            if column.foreign is None:
                break
            last_column = column
            column = column.foreign
        columns.append('%s.%s' % (table, column.name))
        names.append(field.name)

    query = generate_iter_query(columns, joins, ids)
    cursor = db.cursor('cursor_' + kind + '_' + subtable)
    cursor.itersize = 100 * 1000
    cursor.execute(query, ids)
    fields = []
    last_id = None
    for row in cursor:
        id = row[0]
        if last_id != id:
            if fields:
                yield last_id, fields
            last_id = id
            fields = []
        for name, value in zip(names, row[1:]):
            if not value:
                continue
            if isinstance(value, str):
                value = value.decode('utf8')
            elif not isinstance(value, unicode):
                value = unicode(value)
            try:
                fields.append(E.field(value, name=name))
            except ValueError:
                continue # XXX
    if fields:
        yield last_id, fields


def placeholders(ids):
    return ", ".join(["%s" for i in ids])


def grab_next(iter):
    try:
        return iter.next()
    except StopIteration:
        return None


def merge(main, *extra):
    current = map(grab_next, extra)
    for id, fields in main:
        for i, extra_item in enumerate(current):
            if extra_item is not None:
                if extra_item[0] == id:
                    fields.extend(extra_item[1])
                    current[i] = grab_next(extra[i])
        yield id, E.doc(*fields)


def fetch_entities(db, kind, ids=()):
    sources = [iter_main(db, kind, ids)]
    subtables = set()
    for field in schema[kind].iter_multi_fields():
        if field.column.table not in subtables:
            sources.append(iter_sub(db, kind, field.column.table, ids))
            subtables.add(field.column.table)
    return merge(*sources)


def fetch_artists(db, ids=()):
    return fetch_entities(db, 'artist', ids)


def fetch_labels(db, ids=()):
    return fetch_entities(db, 'label', ids)


def fetch_places(db, ids=()):
    return fetch_entities(db, 'place', ids)


def fetch_release_groups(db, ids=()):
    return fetch_entities(db, 'release_group', ids)


def fetch_recordings(db, ids=()):
    return fetch_entities(db, 'recording', ids)


def fetch_releases(db, ids=()):
    return fetch_entities(db, 'release', ids)


def fetch_works(db, ids=()):
    return fetch_entities(db, 'work', ids)


def fetch_all(cfg, db):
    return itertools.chain(
        fetch_artists(db) if cfg.solr.index_artists else [],
        fetch_labels(db) if cfg.solr.index_labels else [],
        fetch_places(db) if cfg.solr.index_places else [],
        fetch_recordings(db) if cfg.solr.index_recordings else [],
        fetch_release_groups(db) if cfg.solr.index_release_groups else [],
        fetch_releases(db) if cfg.solr.index_releases else [],
        fetch_works(db) if cfg.solr.index_works else [])


def fetch_all_updated(cfg, db):
    queue = cfg.schema.name("mbslave") + ".mbslave_solr_queue"
    updated = {}
    cursor = db.cursor()
    cursor.execute("SELECT id, entity_type, entity_id FROM " + queue)
    for id, kind, entity_id in cursor:
        if kind not in updated:
            updated[kind] = set()
        db.cursor().execute("DELETE FROM " + queue + " WHERE id = %s", (id,))
        updated[kind].add(entity_id)
    for kind, ids in updated.iteritems():
        if getattr(cfg.solr, 'index_%ss' % kind):
            missing = set(ids)
            for id, doc in fetch_entities(db, kind, list(ids)):
                missing.remove(id)
                yield E.add(doc)
            if missing:
                yield E.delete(*map(E.id, ['%s:%s' % (kind, id) for id in missing]))
