# COMP3311 21T3 Ass2 ... Python helper functions
# add here any functions to share between Python scripts 
# you must submit this even if you add nothing

def getProgram(db,code):
  cur = db.cursor()
  cur.execute("select * from Programs where code = %s",[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStream(db,code):
  cur = db.cursor()
  cur.execute("select * from Streams where code = %s",[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStudent(db,zid):
  cur = db.cursor()
  qry = """
  select p.*, c.name
  from   People p
         join Students s on s.id = p.id
         join Countries c on p.origin = c.id
  where  p.id = %s
  """
  cur.execute(qry,[zid])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStudentCourseEnrolments(db, zid):
  cur = db.cursor()
  qry = """
  select * from course_enrolments 
  where student = %s;
  """
  cur.execute(qry,[zid])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def subjectDeets(db, zid):
  cur = db.cursor()
  qry = """
    select ce.mark, ce.grade, s.code, s.name, s.uoc, t.code
    from course_enrolments ce, subjects s
        join courses c on s.id = c.subject
        join terms t on t.id = c.term
    where c.id = ce.course and ce.student = %s
    order by t.id, s.code;
  """
  cur.execute(qry,[zid])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info



def getSubjectDetails(db, courseID):
  cur = db.cursor()
  qry = """
  select s.code, s.name, s.uoc
  from subjects as s
    join courses c on s.id = c.subject
  where c.id = %s;
  """
  cur.execute(qry,[courseID])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

# Q2 Helpers
def getProgramSchool(db, code):
  cur = db.cursor()
  qry = """
  select o.longname
  from programs p
    join orgunits o on p.offeredby = o.id
  where p.id = %s
  """
  cur.execute(qry,[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStreamSchool(db, code):
  cur = db.cursor()
  qry = """
  select o.longname
  from orgunits o
  where o.id = %s
  """
  cur.execute(qry,[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info
  
def getAcademicRequirements(db, id):
  cur = db.cursor()
  qry = """
  select aog.type, aog.definition
  from academic_object_groups aog
  where aog.id = %s
  """
  cur.execute(qry,[id])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getProgramRules(db, code):
  cur = db.cursor()
  qry = '''
  select *, aog.type
  from rules r 
    join program_rules pr on pr.rule = r.id
    join academic_object_groups aog on aog.id = r.ao_group
  where pr.program = %s;
  '''
  cur.execute(qry,[code])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getRuleInfo(db, id):
  cur = db.cursor()
  qry = '''
  select * from academic_object_groups
  where id = %s;
  '''
  cur.execute(qry,[id])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getCodeStream(db):
  cur = db.cursor()
  qry = '''
  select code from streams;
  '''
  cur.execute(qry)
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getCodeSubjects(db):
  cur = db.cursor()
  qry = '''
  select code from subjects;
  '''
  cur.execute(qry)
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getStreamName(db, stream):
  cur = db.cursor()
  qry = '''
  select name 
  from streams
  where code = %s;
  '''
  cur.execute(qry,[stream])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

def getSubjectName(db, subject):
  cur = db.cursor()
  qry = '''
  select name 
  from subjects
  where code = %s;
  '''
  cur.execute(qry,[subject])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info[0]

def getStreamRules(db, stream):
  cur = db.cursor()
  qry = '''
  select *, aog.type
  from rules r 
    join stream_rules sr on sr.rule = r.id
    join academic_object_groups aog on aog.id = r.ao_group
    join streams s on s.id = sr.stream
  where s.code = %s;
  '''
  cur.execute(qry,[stream])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

# Q3 Helpers
def getProgramName(db, code):
  cur = db.cursor()
  cur.execute("select name from Programs where id = %s",[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info[0]

def getStreamName(db, code):
  cur = db.cursor()
  cur.execute("select name from streams where code = %s",[code])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info[0]


def getStreamSubjectsRule(db, stream):
  cur = db.cursor()
  qry = '''
  select s.code, r.name, aog.definition
  from rules r
    join stream_rules sr on sr.rule = r.id 
    join streams s on s.id = sr.stream
    join academic_object_groups aog on aog.id = r.ao_group
  where s.code = %s
  '''
  cur.execute(qry,[stream])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getProgramSubjectsRule(db, program):
  cur = db.cursor()
  qry = '''
  select p.code, r.name
  from rules r
    join program_rules pr on pr.rule = r.id 
    join programs p on p.id = pr.program
  where p.code = '%s'
  '''
  cur.execute(qry,[program])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getRequiredSubjects(db, program):
  cur = db.cursor()
  qry = '''
  select s.code, r.name
  from rules r
    join stream_rules sr on sr.rule = r.id 
    join streams s on s.id = sr.stream
  where sr.stream = %s
  '''
  cur.execute(qry,[program])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getProgramStreamRule(db, prog, stream):
  cur = db.cursor()
  qry = '''
  select s.code, r.name, aog.definition
  from rules r
    join stream_rules sr on sr.rule = r.id 
    join program_rules pr on pr.rule = r.id 
    join streams s on s.id = sr.stream and s.id = pr.program
    join academic_object_groups aog on aog.id = r.ao_group
  where pr.program = %s and sr.stream = %s
  '''
  cur.execute(qry,[prog, stream])
  info = cur.fetchall()
  cur.close()
  if not info:
    return None
  else:
    return info

def getLatestProgramStreamCode(db, student):
  cur = db.cursor()
  qry = '''
  select pe.program, s.code
  from program_enrolments pe
    join terms t on t.id = pe.term
    join stream_enrolments se on se.partof = pe.id
    join streams s on se.stream = s.id
  where pe.student = %s
  order by t.id DESC
  limit 1;
  '''
  cur.execute(qry,[student])
  info = cur.fetchone()
  cur.close()
  if not info:
    return None
  else:
    return info

# select pe.program, s.code
# from program_enrolments pe
#   join terms t on t.id = pe.term
#   join stream_enrolments se on se.partof = pe.id
#   join streams s on se.stream = s.id
# where pe.student = 5123788
# order by t.id DESC
# limit 1;

def getProgramSubjects(db, program):
  cur = db.cursor()
  qry = '''
  select aog.definition
  from academic_object_groups aog
    join rules r on r.ao_group = aog.id
    join program_rules pr on pr.rule = r.id
    join programs p on p.id = pr.program
  where p.id = %s and aog.type != 'stream' and aog.defby != 'pattern';
  '''
  cur.execute(qry,[program])
  info = cur.fetchall()
  cur.close()

  l = []
  for tuple in info:
    # print(tuple)
    l += tuple[0].split(',')
  # print(l)
  return l

def getStreamSubjects(db, stream):
  cur = db.cursor()
  qry = '''
  select aog.definition
  from academic_object_groups aog
    join rules r on r.ao_group = aog.id
    join Stream_rules sr on sr.rule = r.id
    join Streams s on s.id = sr.Stream
  where s.code = %s and aog.defby != 'pattern';
  '''
  cur.execute(qry,[stream])
  info = cur.fetchall()
  cur.close()

  l = []
  for tuple in info:
    # print(tuple)
    l += tuple[0].split(',')
  # print(l)
  return l

def getSubjectsCompleted(db, zID):
  cur = db.cursor()
  qry = '''
  select s.code
  from course_enrolments ce, subjects s
      join courses c on s.id = c.subject
      join terms t on t.id = c.term
  where c.id = ce.course and ce.student = %s and 
    ce.grade <>  'AF'
    and ce.grade <> 'FL'
    and ce.grade <> 'UF'
    and ce.grade <> 'E'
    and ce.grade <> 'F'
  order by t.id, s.code;
  '''
  cur.execute(qry,[zID])
  info = cur.fetchall()
  cur.close()

  l = []
  for tuple in info:
    # print(tuple)
    l += tuple[0].split(',')
  # print(l)
  return l

