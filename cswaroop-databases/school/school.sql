-- Inspired from Fedena
-- http://projectfedena.org

create table academic_details (
    registration_id uuid PRIMARY KEY default uuid_generate_v1mc(),
    created_at timestamp default now(),
    updated_at timestamp default now()
);

create table additional_exam_group (
    id uuid PRIMARY KEY default uuid_generate_v1mc(),
    school_id uuid,
    name text,
    batch_id uuid,
    exam_type text,
    is_published boolean DEFAULT false,
    result_oriented boolean DEFAULT false,
    students_list text,
    exam_date date,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
create table additional_exam_score (
    id uuid PRIMARY KEY default uuid_generate_v1mc(),
    additional_exam_group_id uuid REFERENCES additional_exam_group (id),
    school_id uuid,
    student_id uuid,
    additional_exam_id uuid,
    marks numeric,
    grading_level_id uuid,
    remarks text,
    is_failed text,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
create table additional_exams (
    id uuid PRIMARY KEY default uuid_generate_v1mc(),
    school_id uuid,
    additional_exam_group_id uuid REFERENCES additional_exam_group (id),
    subject_id uuid,
    start_time timestamp,
    end_time timestamp,
    max_marks numeric,
    min_marks numeric,
    grading_level_id uuid,
    weightage numeric DEFAULT 0,
    event_id uuid,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
create table additional_field (
    id uuid PRIMARY KEY default uuid_generate_v1mc(),
    school_id uuid,
    name text,
    status boolean,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
create table applicant_addl_field_value (
    id uuid PRIMARY KEY default uuid_generate_v1mc(),
    school_id uuid,
    applicant_addl_field_id uuid REFERENCES additional_field (id),
    option text,
    is_active boolean,
    created_at timestamp default now(),
    updated_at timestamp default now()
);
