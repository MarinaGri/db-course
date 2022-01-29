alter table employee
    add constraint emailTest check ( email ~* '^([\w!#$%&*+\/=?^_`\-{|}~]+|"[\w!#$%&*+\/=?^_`\s{|}~.(),:;<>@\\\[\]]*")+[\w!#$%&*+\/=?^_`{|}~.]*@\w+(\w-)*\.([A-Za-z]+)$' );

alter table employee
    add constraint telTest check ( tel ~* '^\+?[0-9]{11}$' );

alter table employee
    add constraint nameTest check ( surname ~* '[A-ZА-Я].+' and name ~* '[A-ZА-Я].+' and second_name ~* '[A-ZА-Я].+');
