--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: associate_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE associate_skills (
    eid character varying(10) NOT NULL,
    skillid integer NOT NULL,
    reviewed character varying(5),
    pid integer,
    result character varying(20)
);


ALTER TABLE associate_skills OWNER TO postgres;

--
-- Name: associate_test_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE associate_test_details (
    eid character varying(10) NOT NULL,
    skillid integer NOT NULL,
    testid integer NOT NULL,
    score integer,
    result character varying(20),
    status character varying(10),
    pid integer
);


ALTER TABLE associate_test_details OWNER TO postgres;

--
-- Name: competency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE competency (
    cid integer NOT NULL,
    cname character varying(50)
);


ALTER TABLE competency OWNER TO postgres;

--
-- Name: competency_cid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE competency_cid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE competency_cid_seq OWNER TO postgres;

--
-- Name: competency_cid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE competency_cid_seq OWNED BY competency.cid;


--
-- Name: proficiency; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE proficiency (
    pid integer NOT NULL,
    plevel character varying(25)
);


ALTER TABLE proficiency OWNER TO postgres;

--
-- Name: proficiency_pid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE proficiency_pid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE proficiency_pid_seq OWNER TO postgres;

--
-- Name: proficiency_pid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE proficiency_pid_seq OWNED BY proficiency.pid;


--
-- Name: question_bank; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE question_bank (
    qno integer,
    question text,
    option1 text,
    option2 text,
    option3 text,
    option4 text,
    answer text,
    qid integer NOT NULL,
    skillid integer
);


ALTER TABLE question_bank OWNER TO postgres;

--
-- Name: questionbank_qid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE questionbank_qid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE questionbank_qid_seq OWNER TO postgres;

--
-- Name: questionbank_qid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE questionbank_qid_seq OWNED BY question_bank.qid;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE roles (
    roleid character varying(5) NOT NULL,
    rolename character varying(20) NOT NULL,
    is_active character varying(5) NOT NULL
);


ALTER TABLE roles OWNER TO postgres;

--
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE skills (
    skillid integer NOT NULL,
    skillname character varying(20) NOT NULL,
    cid integer
);


ALTER TABLE skills OWNER TO postgres;

--
-- Name: skill_skillid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE skill_skillid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skill_skillid_seq OWNER TO postgres;

--
-- Name: skill_skillid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE skill_skillid_seq OWNED BY skills.skillid;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE teams (
    teamid integer NOT NULL,
    teamname character varying(25),
    teamsize integer,
    team_manager character varying(25),
    team_created date
);


ALTER TABLE teams OWNER TO postgres;

--
-- Name: teams_teamid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE teams_teamid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE teams_teamid_seq OWNER TO postgres;

--
-- Name: teams_teamid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE teams_teamid_seq OWNED BY teams.teamid;


--
-- Name: test_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE test_details (
    testid integer NOT NULL,
    testname character varying(25) NOT NULL,
    testdate date
);


ALTER TABLE test_details OWNER TO postgres;

--
-- Name: testdetails_testid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE testdetails_testid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE testdetails_testid_seq OWNER TO postgres;

--
-- Name: testdetails_testid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE testdetails_testid_seq OWNED BY test_details.testid;


--
-- Name: user_teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE user_teams (
    eid character varying(10),
    teamid integer,
    cid integer
);


ALTER TABLE user_teams OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    eid character varying(10) NOT NULL,
    name character varying(30) NOT NULL,
    email character varying(30) NOT NULL,
    password character varying(100) NOT NULL,
    phno bigint,
    roleid character varying(5)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: competency cid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competency ALTER COLUMN cid SET DEFAULT nextval('competency_cid_seq'::regclass);


--
-- Name: proficiency pid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proficiency ALTER COLUMN pid SET DEFAULT nextval('proficiency_pid_seq'::regclass);


--
-- Name: question_bank qid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY question_bank ALTER COLUMN qid SET DEFAULT nextval('questionbank_qid_seq'::regclass);


--
-- Name: skills skillid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills ALTER COLUMN skillid SET DEFAULT nextval('skill_skillid_seq'::regclass);


--
-- Name: teams teamid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY teams ALTER COLUMN teamid SET DEFAULT nextval('teams_teamid_seq'::regclass);


--
-- Name: test_details testid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY test_details ALTER COLUMN testid SET DEFAULT nextval('testdetails_testid_seq'::regclass);


--
-- Data for Name: associate_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY associate_skills (eid, skillid, reviewed, pid, result) FROM stdin;
14211A0550	1	yes	4	Certified
14211A0550	28	yes	4	Certified
14211A0550	2	yes	1	Not Certified
\.


--
-- Data for Name: associate_test_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY associate_test_details (eid, skillid, testid, score, result, status, pid) FROM stdin;
14211A0550	2	89	4	Not Certified	taken	1
\.


--
-- Data for Name: competency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY competency (cid, cname) FROM stdin;
1	Open Source
2	Microsoft Tools
3	Web Technologies
\.


--
-- Data for Name: proficiency; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY proficiency (pid, plevel) FROM stdin;
1	below average
2	average
3	above average
4	good
5	excellent
0	Not Assigned
\.


--
-- Data for Name: question_bank; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY question_bank (qno, question, option1, option2, option3, option4, answer, qid, skillid) FROM stdin;
1	class Base {\n    public void show() {\n       System.out.println("Base::show() called");\n    }\n}\n  \nclass Derived extends Base {\n    public void show() {\n       System.out.println("Derived::show() called");\n    }\n}\n  \npublic class Main {\n    public static void main(String[] args) {\n        Base b = new Derived();;\n        b.show();\n    }\n}	Derived::show() called	Base::show() called	Compiler Error	Runtime Error	Derived::show() called	601	1
2	class Base {\n    final public void show() {\n       System.out.println("Base::show() called");\n    }\n}\n  \nclass Derived extends Base {\n    public void show() {\n       System.out.println("Derived::show() called");\n    }\n}\n  \nclass Main {\n    public static void main(String[] args) {\n        Base b = new Derived();;\n        b.show();\n    }\n}	Base::show() called	Derived::show() called	Compiler Error	Runtime Error	Compiler Error	602	1
3	Which of the following is true about inheritance in Java?\n\n1) Private methods are final.\n2) Protected members are accessible within a package and \n   inherited classes outside the package.\n3) Protected methods are final.\n4) We cannot override private methods. 	1, 2 and 4	Only 1 and 2	1, 2 and 3	2, 3 and 4	1, 2 and 4	603	1
4	class Base {\npublic void Print() {\nSystem.out.println("Base");\n}\n}\n\nclass Derivedextends Base {\npublic void Print() {\nSystem.out.println("Derived");\n}\n}\n\nclass Main{\npublic static void DoPrint( Base o ) {\no.Print();\n}\npublic static void main(String[] args) {\nBase x =new Base();\nBase y =new Derived();\nDerived z =new Derived();\nDoPrint(x);\nDoPrint(y);\nDoPrint(z);\n}\n}	Base\nDerived\nDerived	Base\nDerived\nBase	Base\nDerived\nBase	Compiler Error	Base\nDerived\nDerived	604	1
5	Which of the following is true about inheritance in Java. 1) In Java all classes inherit from the Object class directly or indirectly. The Object class is root of all classes. 2) Multiple inheritance is not allowed in Java. 3) Unlike C++, there is nothing like type of inheritance in Java where we can specify whether the inheritance is protected, public or private.	1, 2 and 3	1 and 2	2 and 3	1 and 3	1, 2 and 3	605	1
6	Which of the following is/are true about packages in Java?\n1) Every class is part of some package. \n2) All classes in a file are part of the same package. \n3) If no package is specified, the classes in the file \n   go into a special unnamed package \n4) If no package is specified, a new package is created with \n   folder name of class and the class is put in this package. 	Only 1, 2 and 3	Only 1, 2 and 4	Only 4	Only 1 and 3	Only 1, 2 and 3	606	1
7	Which of the following is/are advantages of packages?	Packages avoid name clashes	Classes, even though they are visible outside their package, can have fields visible to packages only	We can have hidden classes that are used by the packages, but not visible outside.	All of the above	All of the above	607	1
8	Predict the output of following Java program\n// Note static keyword after import.\nimport static java.lang.System.*;\n   \nclass StaticImportDemo\n{\n   public static void main(String args[])\n   {      \n        out.println("GeeksforGeeks");\n   }\n}	Compiler Error	Runtime Error	GeeksforGeeks	None of the above	GeeksforGeeks	608	1
9	Which of the following is FALSE about abstract classes in Java	If we derive an abstract class and do not implement all the abstract methods, then the derived class should also be marked as abstract using 'abstract' keyword	Abstract classes can have constructors	A class can be made abstract without any abstract method	A class can inherit from multiple abstract classes.	A class can inherit from multiple abstract classes.	609	1
10	Which of the following is true about interfaces in java.\n\n1) An interface can contain following type of members.\n....public, static, final fields (i.e., constants) \n....default and static methods with bodies\n\n2) An instance of interface can be created.\n\n3) A class can implement multiple interfaces.\n\n4) Many classes can implement the same interface.	1, 3 and 4	1, 2 and 4	2, 3 and 4	1, 2, 3 and 4	1, 3 and 4	610	1
11	abstract class demo\n{\n    public int a;\n    demo()\n    {\n        a = 10;\n    }\n \n    abstract public void set();\n     \n    abstract final public void get();\n \n}\n \nclass Test extends demo\n{\n \n    public void set(int a)\n    {\n        this.a = a;\n    }\n \n    final public void get()\n    {\n        System.out.println("a = " + a);\n    }\n \n    public static void main(String[] args)\n    {\n        Test obj = new Test();\n        obj.set(20);\n        obj.get();\n    }\n}	a = 10	a = 20	Compilation error	Runtime Error	Compilation error	611	1
12	Predict the output of following Java program?\nclass Test {\n  int i;\n} \nclass Main {\n   public static void main(String args[]) { \n     Test t; \n     System.out.println(t.i); \n}  	0	garbage value	compiler error	runtime error		612	1
13	Predict the output of following Java program\nclass Test {\n  int i;\n} \nclass Main {\n  public static void main(String args[]) { \n      Test t = new Test(); \n      System.out.println(t.i);\n   } \n}	garbage value	0	compiler error	runtime error		613	1
14	class demo\n{\n    int a, b;\n     \n    demo()\n    {\n        a = 10;\n        b = 20;\n    }\n     \n    public void print()\n    {\n        System.out.println ("a = " + a + " b = " + b + "\\n");\n    }\n}\n \nclass Test\n{\n \n    public static void main(String[] args)\n    {\n        demo obj1 = new demo();\n        demo obj2 = obj1;\n \n        obj1.a += 1;\n        obj1.b += 1;\n \n        System.out.println ("values of obj1 : ");\n        obj1.print();\n        System.out.println ("values of obj2 : ");\n        obj2.print();\n \n    }\n}	Compile error	values of obj1: \na = 11 b = 21\nvalues of obj2: \na = 11 b = 21	values of obj1: \na = 11 b = 21\nvalues of obj2: \na = 10 b = 20	values of obj1: \na = 11 b = 20\nvalues of obj2: \na = 10 b = 21	values of obj1: \na = 11 b = 21\nvalues of obj2: \na = 11 b = 21	614	1
15	1. What is the type of variable ‘b’ and ‘d’ in the below snippet?\nint a[], b;\nint []c, d;	‘b’ and ‘d’ are int	‘b’ and ‘d’ are arrays of type int	‘b’ is int variable; ‘d’ is int array	‘d’ is int variable; ‘b’ is int array	‘b’ is int variable; ‘d’ is int array	615	1
16	Which of these is an incorrect array declaration?	int arr[] = new int[5] ;	int [] arr = new int[5] ;	int arr[];\narr = new int[5];	int arr[] = int [5] new;	int arr[] = int [5] new;	616	1
17	What will this code print?\n\nint arr[] = new int [5];\nSystem.out.print(arr);	0	value stored in arr[0].	0	Garbage value	Garbage value	617	1
18	What is the output of below snippet?\n\nObject[] names = new String[3];\nnames[0] = new Integer(0);	ArrayIndexOutOfBoundsException	ArrayStoreException	Compilation Error	Code runs successfully	ArrayStoreException	618	1
19	Generics does not work with?	Set	List	Tree	Array	Array	619	1
20	How to sort an array?	 Array.sort()	Arrays.sort()	Collection.sort()	System.sort()	Arrays.sort()	620	1
21	Where is array stored in memory?	heap space	 stack space	heap space and stack space	first generation memory	heap space	621	1
22	When does method overloading is determined?	At run time	At compile time	 At coding time	At execution time	 At compile time	622	1
23	Which concept of Java is a way of converting real world objects in terms of class?	Polymorphism	Encapsulation	Abstraction	Inheritance	Abstraction	623	1
24	Which concept of Java is achieved by combining methods and attribute into a class?	 Encapsulation	Inheritance	 Polymorphism	Abstration	Encapsulation	624	1
25	What is it called if an object has its own lifecycle and there is no owner?	Aggregation	Composition	Encapsulation	Association	Association	625	1
26	What is it called where object has its own lifecycle and child object cannot belong to another parent object?	Aggregation	Compostion	Encapsulation	 Association	Aggregation	626	1
27	What is it called where child object gets killed if parent object is killed?	Aggregation	Composition	Encapsulation	Association	Composition	627	1
28	Which of these keywords is used to make a class?	class	struct	 int	none of the mentioned	class	628	1
29	Which of the following is a valid declaration of an object of class Box?	Box obj = new Box();	 Box obj = new Box;	obj = new Box();	new Box obj;	Box obj = new Box();	629	1
30	Which of these operators is used to allocate memory for an object?	malloc	alloc	new	give	 new	630	1
31	Which of these statement is incorrect?	Every class must contain a main() method	Applets do not require a main() method at all	There can be only one main() method in a program	main() method must be made public	Every class must contain a main() method	631	1
32	 Which of the following statements is correct?	Public method is accessible to all other classes in the hierarchy	Public method is accessible only to subclasses of its parent class	Public method can only be called by object of its class	Public method can be accessed by calling object of the public class	Public method is accessible to all other classes in the hierarchy	632	1
33	class box \n    {\n        int width;\n        int height;\n        int length;\n    } \n    class mainclass \n    {\n        public static void main(String args[]) \n        {        \n            box obj1 = new box();\n            box obj2 = new box();\n            obj1.height = 1;\n            obj1.length = 2;\n            obj1.width = 1;\n            obj2 = obj1;\n            System.out.println(obj2.height);\n        } \n    }	1	2	 Runtime error	Garbage valueGarbage value	1	633	1
34	class box \n   {\n        int width;\n        int height;\n        int length;\n   } \n    class mainclass \n    {\n        public static void main(String args[]) \n        {        \n            box obj = new box();\n            System.out.println(obj);\n        } \n    }	0	1	Runtime error	classname@hashcode in hexadecimal form	classname@hashcode in hexadecimal form	634	1
35	What is the return type of a method that does not returns any value?	int	float	void	double	void	635	1
36	What is the process of defining more than one method in a class differentiated by method signature?	Function overriding	Function overloading	Function doubling	None of the mentioned	Function overloading	636	1
37	Which of the following is a method having same name as that of it’s class?	finalize	delete	class	constructor	constructor	637	1
38	Which method can be defined only once in a program?	main method	 finalize method	static method	private method	 main method	638	1
39	Which of these statement is incorrect?	All object of a class are allotted memory for the all the variables defined in the class	If a function is defined public it can be accessed by object of other class by inheritation	main() method must be made public	All object of a class are allotted memory for the methods defined in the class	All object of a class are allotted memory for the methods defined in the class	639	1
40	 class equality \n    {\n        int x;\n        int y;\n        boolean isequal()\n        {\n            return(x == y);  \n        } \n    }    \n    class Output \n    {\n        public static void main(String args[])\n        {\n            equality obj = new equality();\n            obj.x = 5;\n            obj.y = 5;\n            System.out.println(obj.isequal());\n        } \n    }	FALSE	 true	0	1	TRUE	640	1
41	Which of these is not abstract?	Thread	AbstractList	List	 None of the Mentioned	Thread	641	1
42	If a class inheriting an abstract class does not define all of its function then it will be known as?	Abstract	A simple class	Static class	None of the mentioned	Abstract	642	1
43	 What is the output of this program?\n\n    class A \n    {\n        public int i;\n        private int j;\n    }    \n    class B extends A \n    {\n        void display() \n        {\n            super.j = super.i + 1;\n            System.out.println(super.i + " " + super.j);\n        }\n    }    \n    class inheritance \n   {\n        public static void main(String args[])\n        {\n            B obj = new B();\n            obj.i=1;\n            obj.j=2;   \n            obj.display();     \n        }\n   }	2 2	3 3	Runtime Error	Compilation Error	Compilation Error	643	1
44	What is the output of this program?\n\n    class A \n    {\n        public int i;\n        public int j;\n        A() \n       {\n            i = 1;\n            j = 2;\n        }\n    }    \n    class B extends A \n    {\n        int a;\n        B() \n        {\n            super();\n        } \n    }    \n    class super_use \n    {\n        public static void main(String args[])\n        {\n            B obj = new B();\n            System.out.println(obj.i + " " + obj.j)     \n        }\n   }	1 2	2 1	Runtime Error	Compilation Error	1 2	644	1
45	What is the output of this program?\n\n    abstract class A \n    {\n        int i;\n        abstract void display();\n    }    \n    class B extends A \n    {\n        int j;\n        void display() \n        {\n            System.out.println(j);\n        }\n    }    \n    class Abstract_demo \n    {\n        public static void main(String args[])\n        {\n            B obj = new B();\n            obj.j=2;\n            obj.display();    \n        }\n   }	0	2	 Runtime Error	Compilation Error	2	645	1
46	 What is the output of this program?\n\n    class A \n    {\n        int i;\n        void display() \n        {\n            System.out.println(i);\n        }\n    }    \n    class B extends A \n    {\n        int j;\n        void display() \n        {\n            System.out.println(j);\n        }\n    }    \n    class method_overriding \n    {\n        public static void main(String args[])\n        {\n            B obj = new B();\n            obj.i=1;\n            obj.j=2;   \n            obj.display();     \n        }\n   }	0	1	2	Compilation Error	2	646	1
47	What is the output of this program?\n\n    class A \n    {\n        public int i;\n        protected int j;\n    }    \n    class B extends A \n    {\n        int j;\n        void display() \n        {\n            super.j = 3;\n            System.out.println(i + " " + j);\n        }\n    }    \n    class Output \n    {\n        public static void main(String args[])\n        {\n            B obj = new B();\n            obj.i=1;\n            obj.j=2;   \n            obj.display();     \n        }\n   }	1 2	2 1	1 3	3 1		647	1
48	 Which of the following keywords is used for throwing exception manually?	finally	try	throw	 catch	throw	648	1
49	Which of the following classes can catch all exceptions which cannot be caught?	RuntimeException	Error	Exception	ParentException	Exception	649	1
50	Which of the following operators is used to generate instance of an exception which can be thrown using throw?	thrown	 alloc	malloc	new	 new	650	1
51	Which of the following handles the exception when catch is not used?	 finally	throw handler	default handler	 java run time system	 default handler	651	1
52	Which part of code gets executed whether exception is caught or not?	finally	try	catch	throw	finally	652	1
53	What exception thrown by parseInt() method?	ArithmeticException	ClassNotFoundException	 NullPointerException	NumberFormatException	NumberFormatException	653	1
54	Which of the following should be true of the object thrown by a thrown statement?	Should be assignable to String type	Should be assignable to Exception type	Should be assignable to Throwable type	Should be assignable to Error type	Should be assignable to Throwable type	654	1
55	What is the output of this program?\n\n    class exception_handling \n    {\n        public static void main(String args[]) \n        {\n            try \n            {\n                int a = args.length;\n                int b = 10 / a;\n                System.out.print(a);\n                try \n                {\n                    if (a == 1)\n                        a = a / a - a;\n                    if (a == 2) \n                    {\n                        int []c = {1};\n                        c[8] = 9;\n                    }\n                }\n                catch (ArrayIndexOutOfBoundException e) \n                {\n                    System.out.println("TypeA");\n                }\n                catch (ArithmeticException e) \n                {\n                    System.out.println("TypeB");\n                }\n            }\n        }\n    }	TypeA	TypeB	Compiler Time Error	 0TypeB	Compiler Time Error	655	1
56	What is the output of this program?\n\n    class exception_handling \n    {\n        public static void main(String args[]) \n        {\n            try \n            {\n                System.out.print("A");\n                throw new NullPointerException ("Hello");\n            }\n            catch(ArithmeticException e) \n            {\n                System.out.print("B");                \n            }\n        }\n    }	A	B	Hello	Runtime Exception		656	1
57	What is the output of this program?\n\n    class exception_handling \n    {\n        static void throwexception() throws ArithmeticException \n        {        \n            System.out.print("0");\n            throw new ArithmeticException ("Exception");\n        }\n        public static void main(String args[]) \n        {\n            try \n            {\n                throwexception();\n            }\n            catch (ArithmeticException e) \n            {\n                System.out.println("A");\n            }\n        }\n    }	A	O	OA	Exception		657	1
58	What is the output of this program?\n\npublic class San \n{\n    public static void main(String args[])\n    {\n        try \n        {\n            System.out.print("Hello world ");\n        }\n        finally \n        {\n            System.out.println("Finally executing ");\n        }\n    }\n}	The program will not compile because no exceptions are specified	The program will not compile because no catch clauses are specified	 Hello world	Hello world Finally executing	Hello world Finally executing	658	1
59	Which of these classes implements Set interface?	ArrayList	HashSet	LinkedList	DynamicList	HashSet	659	1
60	Which of these method is used to add an element to the start of a LinkedList object?	add()	first()	AddFirst()	addFirst()	addFirst()	660	1
61	Which of these method of HashSet class is used to add elements to its object?	add()	 Add()	addFirst()	insert()	add()	661	1
62	Which of these methods can be used to delete the last element in a LinkedList object?	 remove()	delete()	removeLast()	deleteLast()	removeLast()	662	1
63	Which of these method is used to change an element in a LinkedList Object?	change()	 set()	redo()	add()	set()	663	1
64	What is the output of this program?\n\n    import java.util.*;\n    class Linkedlist \n    {\n        public static void main(String args[]) \n        {\n            LinkedList obj = new LinkedList();\n            obj.add("A");\n            obj.add("B");\n            obj.add("C");\n            obj.addFirst("D");\n            System.out.println(obj);\n        }\n    }	[A, B, C].	[D, B, C].	[A, B, C, D].	[D, A, B, C].	[D, A, B, C].	664	1
65	 What is the output of this program?\n\n    import java.util.*;\n    class Linkedlist \n    {\n        public static void main(String args[]) \n        {\n            LinkedList obj = new LinkedList();\n            obj.add("A");\n            obj.add("B");\n            obj.add("C");\n            obj.removeFirst();\n            System.out.println(obj);\n        }\n    }	[A, B].	[B, C].	[A, B, C, D].	[A, B, C].	[B, C].	665	1
66	What is the output of this program?\n\n    import java.util.*; \n    class Output \n    {\n        public static void main(String args[]) \n        { \n            TreeSet t = new TreeSet();\n            t.add("3");\n            t.add("9");\n            t.add("1");\n            t.add("4");\n            t.add("8"); \n            System.out.println(t);\n        }\n    }	[1, 3, 5, 8, 9].	[3, 4, 1, 8, 9].	 [9, 8, 4, 3, 1].	[1, 3, 4, 8, 9].	[1, 3, 4, 8, 9].	666	1
67	Which of these interface declares core method that all collections will have?	 set	EventListner	Comparator	Collection	Collection	667	1
68	Which of these interface handle sequences?	Set	List	Comparator	Collection	List	668	1
69	Which of these interface is not a part of Java’s collection framework?	List	Set	SortedMap	 SortedList	SortedList	669	1
70	Which of these interface must contain a unique element?	Set	List	Array	Collection	Set	670	1
71	What is the output of this program?\n\n    import java.util.*;\n    class Maps \n    {\n        public static void main(String args[]) \n        {\n            TreeMap obj = new TreeMap();\n            obj.put("A", new Integer(1));\n            obj.put("B", new Integer(2));\n            obj.put("C", new Integer(3));\n            System.out.println(obj.entrySet());\n        }\n    }	[A, B, C].	[1, 2, 3].	 {A=1, B=2, C=3}	[A=1, B=2, C=3].	[A=1, B=2, C=3].	671	1
72	What is the output of this program?\n\n    import java.util.*;\n    class vector \n    {\n        public static void main(String args[]) \n        {\n            Vector obj = new Vector(4,2);\n            obj.addElement(new Integer(3));\n            obj.addElement(new Integer(2));\n            obj.addElement(new Integer(5));\n            obj.removeAll(obj);\n            System.out.println(obj.isEmpty());\n        }\n    }	0	1	TRUE	FALSE	TRUE	672	1
73	What is the output of this program?\n\n    import java.util.*;\n    class Bitset \n    {\n        public static void main(String args[]) \n        {\n            BitSet obj = new BitSet(5);\n            for (int i = 0; i < 5; ++i)\n                obj.set(i);\n            obj.clear(2);\n            System.out.print(obj);\n        }\n    }	 {0, 1, 3, 4}	{0, 1, 2, 4}	 {0, 1, 2, 3, 4}	{0, 0, 0, 3, 4}	{0, 1, 3, 4}	673	1
74	Which of the following would compile without error?	int a = Math.abs(-5);	int b = Math.abs(5.0);	int c = Math.abs(5.5F);	int d = Math.abs(5L);	int a = Math.abs(-5);	674	1
97	Which class does not override the equals() and hashCode() methods, inheriting them directly from class Object?	java.lang.String	java.lang.Double	java.lang.StringBuffer	java.lang.Character	java.lang.StringBuffer	697	1
75	Select how you would start the program to cause it to print: Arg is 2\n\npublic class Myfile \n{ \n    public static void main (String[] args) \n    {\n        String biz = args[1]; \n        String baz = args[2]; \n        String rip = args[3]; \n        System.out.println("Arg is " + rip); \n    } \n}	java Myfile 222	java Myfile 1 2 2 3 4	java Myfile 1 3 2 2	java Myfile 0 1 2 3	java Myfile 0 1 2 3	675	1
76	What is the name of the method used to start a thread execution?	init();	start();	run();	resume();	start();	676	1
77	Which cannot directly cause a thread to stop executing?	Calling the SetPriority() method on a Thread object.	Calling the wait() method on an object.	Calling notify() method on an object.	Calling read() method on an InputStream object.	Calling notify() method on an object.	677	1
78	Which of the following will directly stop the execution of a Thread?	wait()	notify()	notifyall()	exits synchronized code	wait()	678	1
79	Which method must be defined by a class implementing the java.lang.Runnable interface?	void run()	public void run()	public void start()	void run(int priority)	public void run()	679	1
80	Which will contain the body of the thread?	run();	start();	stop();	main();	run();	680	1
81	 Which method registers a thread in a thread scheduler?\n	run();	construct();	start();	register();	start();	681	1
82	Assume the following method is properly synchronized and called from a thread A on an object B:\n\nwait(2000);\n\nAfter calling this method, when will the thread A become a candidate to get another turn at the CPU?	After thread A is notified, or after two seconds.	After the lock on B is released, or after two seconds.	Two seconds after thread A is notified.	Two seconds after lock B is released.	After thread A is notified, or after two seconds.	682	1
83	Which of the following will not directly cause a thread to stop?	notify();	wait();	InputStream access	sleep()	notify();	683	1
84	Which class or interface defines the wait(), notify(),and notifyAll() methods?	object	thread	runnable	class	object	684	1
85	Which is true about an anonymous inner class?	It can extend exactly one class and implement exactly one interface.	It can extend exactly one class and can implement multiple interfaces.	It can extend exactly one class or implement exactly one interface.	It can implement multiple interfaces regardless of whether it also extends a class.	It can extend exactly one class and can implement multiple interfaces.	685	1
86	 \nWhich is true about a method-local inner class?	It must be marked final.	It must be marked final.	It can be marked public.	It can be marked static.	It must be marked final.	686	1
87	Which statement is true about a static nested class?	You must have a reference to an instance of the enclosing class in order to instantia	It does not have access to nonstatic members of the enclosing class.	It's variables and methods must be static.	It must extend the enclosing class.	It does not have access to nonstatic members of the enclosing class	687	1
88	Which constructs an anonymous inner class instance?	Runnable r = new Runnable() { };	Runnable r = new Runnable(public void run() { });	Runnable r = new Runnable { public void run(){}};	System.out.println(new Runnable() {public void run() { }});	System.out.println(new Runnable() {public void run() { }});	688	1
89	What will be the output of the program (when you run with the -ea option) ?\n\npublic class Test \n{  \n    public static void main(String[] args) \n    {\n        int x = 0;  \n        assert (x > 0) : "assertion failed"; /* Line 6 */\n        System.out.println("finished"); \n    } \n}	finished	Compilation fails.	An AssertionError is thrown.	An AssertionError is thrown and finished is output.	15 15	689	1
90	public class Test2 \n{\n    public static int x;\n    public static int foo(int y) \n    {\n        return y * 2;\n    }\n    public static void main(String [] args) \n    {\n        int z = 5;\n        assert z > 0; /* Line 11 */\n        assert z > 2: foo(z); /* Line 12 */\n        if ( z < 7 )\n            assert z > 4; /* Line 14 */\n\n        switch (z) \n        {\n            case 4: System.out.println("4 ");\n            case 5: System.out.println("5 ");\n            default: assert z < 10;\n        }\n\n        if ( z < 10 )\n            assert z > 4: z++; /* Line 22 */\n        System.out.println(z);\n    }\n}\nwhich line is an example of an inappropriate use of assertions?	line 11	line 12	line 14	line 22		690	1
91	 \nWhat will be the output of the program?\n\nclass PassA \n{\n    public static void main(String [] args) \n    {\n        PassA p = new PassA();\n        p.start();\n    }\n\n    void start() \n    {\n        long [] a1 = {3,4,5};\n        long [] a2 = fix(a1);\n        System.out.print(a1[0] + a1[1] + a1[2] + " ");\n        System.out.println(a2[0] + a2[1] + a2[2]);\n    }\n\n    long [] fix(long [] a3) \n    {\n        a3[1] = 7;\n        return a3;\n    }\n}	12 15	15 15	3 4 5 3 7 5	3 7 5 3 7 5		691	1
92	 \nWhat will be the output of the program?\n\nclass Test \n{\n    public static void main(String [] args) \n    {\n        Test p = new Test();\n        p.start();\n    }\n\n    void start() \n    {\n        boolean b1 = false;\n        boolean b2 = fix(b1);\n        System.out.println(b1 + " " + b2);\n    }\n\n    boolean fix(boolean b1) \n    {\n        b1 = true;\n        return b1;\n    }\n}	true true	false false	true false	false true	false true	692	1
93	public void foo( boolean a, boolean b)\n{ \n    if( a ) \n    {\n        System.out.println("A"); /* Line 5 */\n    } \n    else if(a && b) /* Line 7 */\n    { \n        System.out.println( "A && B"); \n    } \n    else /* Line 11 */\n    { \n        if ( !b ) \n        {\n            System.out.println( "notB") ;\n        } \n        else \n        {\n            System.out.println( "ELSE" ) ; \n        } \n    } \n}	If a is true and b is true then the output is "A && B"	If a is true and b is false then the output is "notB"	If a is false and b is true then the output is "ELSE"	If a is false and b is false then the output is "ELSE"	If a is false and b is true then the output is "ELSE"	693	1
94	public void test(int x) \n{ \n    int odd = 1; \n    if(odd) /* Line 4 */\n    {\n        System.out.println("odd"); \n    } \n    else \n    {\n        System.out.println("even"); \n    } \n}\nWhich statement is true?	Compilation fails.	"odd" will always be output.	"even" will always be output.	"odd" will be output for odd values of x, and "even" for even values.	Compilation fails.	694	1
95	public class While \n{\n    public void loop() \n    {\n        int x= 0;\n        while ( 1 ) /* Line 6 */\n        {\n            System.out.print("x plus one is " + (x + 1)); /* Line 8 */\n        }\n    }\n}\nWhich statement is true?	There is a syntax error on line 1.\n	There are syntax errors on lines 1 and 6.	There are syntax errors on lines 1, 6, and 8.	There is a syntax error on line 6.	There is a syntax error on line 6.	695	1
96	 \nSuppose that you would like to create an instance of a new Map that has an iteration order that is the same as the iteration order of an existing instance of a Map. Which concrete implementation of the Map interface should be used for the new instance?	TreeMap	HashMap	LinkedHashMap	The answer depends on the implementation of the existing instance.	LinkedHashMap	696	1
98	 \nWhich collection class allows you to grow or shrink its size and provides indexed access to its elements, but whose methods are not synchronized?	java.util.HashSet	java.util.LinkedHashSet	java.util.List	java.util.ArrayList	java.util.ArrayList	698	1
99	You need to store elements in a collection that guarantees that no duplicates are stored and all elements can be accessed in natural order. Which interface provides that capability?	java.util.Map	java.util.Set	java.util.List	java.util.Collection	java.util.Set	699	1
100	Which interface does java.util.Hashtable implement?	Java.util.Map	Java.util.List	Java.util.HashTable	Java.util.Collection	Java.util.Map	700	1
1	What will be the output of the following code :\nprint type(type(int))	type int	type type	Error	0	type type	701	2
2	What is the output of the following code :\nL = [ a , b , c , d ]\nprint "".join(L)	Error	None	abcd	[‘a’,’b’,’c’,’d’]	abcd	702	2
3	What is the output of the following segment :\nchr(ord( A ))	A	B	a	Error	A	703	2
4	What is the output of the following program :\ny = 8\nz = lambda x : x * y\nprint z(6)	48	14	64	None of the above	48	704	2
5	What is called when a function is defined inside a class?	Module	Class	Another Function	Method	Method	705	2
6	Which of the following is the use of id() function in python?	Id returns the identity of the object	Every object doesn’t have a unique id	All of the mentioned	None of the mentioned	Id returns the identity of the object	706	2
7	What is the output of the following program :\nimport re\nsentence =  horses are fast \nregex = re.compile( (?P<animal>\\w+) (?P<verb>\\w+) (?P<adjective>\\w+) )\nmatched = re.search(regex, sentence)\nprint(matched.groupdict())	{ animal :  horses , verb : are , adjective: fast}	(‘horses’, ‘are’, ‘fast’)	‘horses are fast 	are 	{‘animal’: ‘horses’, ‘verb’: ‘are’, ‘adjective’: ‘fast’}	707	2
8	Suppose list1 is [3, 4, 5, 20, 5, 25, 1, 3], what is list1 after list1.pop(1)?	[3, 4, 5, 20, 5, 25, 1, 3]	[1, 3, 3, 4, 5, 5, 20, 25]	[3, 5, 20, 5, 25, 1, 3]	[1, 3, 4, 5, 20, 5, 25]	[3, 5, 20, 5, 25, 1, 3]	708	2
9	time.time() returns ________	\nthe current time	the current time in milliseconds	the current time in milliseconds since midnight	the current time in milliseconds since midnight, January 1, 1970 GMT (the Unix time)	the current time in milliseconds since midnight, January 1, 1970 GMT (the Unix time)	709	2
10	What is the output of the following code :\nprint 9//2	4.5	4	0	error	4	710	2
11	Which function overloads the >> operator?	more()	gt()	ge()	None of the above	None of the above	711	2
12	Which operator is overloaded by the or() function?	||	|	//	/	|	712	2
13	What is the output of the following program :\ni = 0\nwhile i < 3:\n       print i\n       i++\n       print i+1	0 2 1 3 2 4	0 1 2 3 4 5	Error	1 0 2 4 3 5	Error	713	2
14	Which of these is not a core data type?	Lists	Dictionary	Tuples	Class	Class	714	2
15	What data type is the object below ? L = [1, 23, ‘hello’, 1]	Lists	Dictionary	Tuples	Array	List	715	2
16	Which of the following function convert a string to a float in python?	int(x [,base])	long(x [,base] )	float(x)	str(x)	float(x)	716	2
17	Which of the following statement(s) is TRUE?\nA hash function takes a message of arbitrary length and generates a fixed length code.\nA hash function takes a message of fixed length and generates a code of variable length.\nA hash function may give the same hash value for distinct messages.	I only	II and III only	I and III only	II only	I and III only	717	2
18	1. What is the output of the code snippet shown below?\n\nX=”hi”\nprint(“05d”%X)	00000hi	000hi	hi000	error	error	718	2
19	Consider the snippet of code shown below and predict the output.\n\nX=”san-foundry”\nprint(“%56s”,X)	56 blank spaces before san-foundry	56 blank spaces before san and foundry	56 blank spaces after san-foundry	no change	56 blank spaces before san-foundry	719	2
20	What is the output of the following expression if x=456?\n\nprint("%-06d"%x)	450006	456000	456	error	456	720	2
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY roles (roleid, rolename, is_active) FROM stdin;
003	admin	yes
002	Employee	yes
001	Manager	yes
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY skills (skillid, skillname, cid) FROM stdin;
1	JAVA	1
2	PYTHON	1
3	HTML	3
4	CSS	3
5	JAVASCRIPT	3
6	BOOTSTRAP	3
7	.NET	2
8	MS SQL	2
28	JQUERY	3
\.


--
-- Data for Name: teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY teams (teamid, teamname, teamsize, team_manager, team_created) FROM stdin;
24	SEAM	2	ZISHAN KHAN	2018-03-15
\.


--
-- Data for Name: test_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY test_details (testid, testname, testdate) FROM stdin;
89	PYTHON1521105612.4392223	2018-03-15
\.


--
-- Data for Name: user_teams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY user_teams (eid, teamid, cid) FROM stdin;
14211A0550	24	1
14211M0000	24	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY users (eid, name, email, password, phno, roleid) FROM stdin;
14211A0000	Admin	ADMIN@SEAM.COM	$5$rounds=535000$Z5/2.UXONvTq71rW$efNCU7Bhy7wYlHO//Ogv/c9lysLFAJt.ybRid2oSen9	9999999999	003
14211A0550	PRAKASH CHANDRA	PRAKASH.CSE2018@GMAIL.COM	$5$rounds=535000$pGAB9suMF9/m9q33$cNoaih1UGSlWKxvXAEVb7LAld2QLpkRgwJwYs5lT29.	9876543210	002
14211M0000	ZISHAN KHAN	ZISHAN@GMAIL.COM	$5$rounds=535000$KI.d3g4XRgj0LhSb$8o8tDYw5rhQNlZ4owdX1CgX.Y2JblDxIei72ytv7YM7	9876543424	001
\.


--
-- Name: competency_cid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('competency_cid_seq', 3, true);


--
-- Name: proficiency_pid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('proficiency_pid_seq', 1, false);


--
-- Name: questionbank_qid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('questionbank_qid_seq', 720, true);


--
-- Name: skill_skillid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('skill_skillid_seq', 28, true);


--
-- Name: teams_teamid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('teams_teamid_seq', 24, true);


--
-- Name: testdetails_testid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('testdetails_testid_seq', 89, true);


--
-- Name: users associates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT associates_pkey PRIMARY KEY (eid);


--
-- Name: competency competency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY competency
    ADD CONSTRAINT competency_pkey PRIMARY KEY (cid);


--
-- Name: associate_skills mapskill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_skills
    ADD CONSTRAINT mapskill_pkey PRIMARY KEY (eid, skillid);


--
-- Name: associate_test_details maptestdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_test_details
    ADD CONSTRAINT maptestdetails_pkey PRIMARY KEY (eid, skillid, testid);


--
-- Name: proficiency proficiency_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY proficiency
    ADD CONSTRAINT proficiency_pkey PRIMARY KEY (pid);


--
-- Name: question_bank questionbank_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY question_bank
    ADD CONSTRAINT questionbank_pkey PRIMARY KEY (qid);


--
-- Name: roles role_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT role_pkey PRIMARY KEY (roleid);


--
-- Name: skills skill_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skill_pkey PRIMARY KEY (skillid);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (teamid);


--
-- Name: test_details testdetails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY test_details
    ADD CONSTRAINT testdetails_pkey PRIMARY KEY (testid);


--
-- Name: teams u_team; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY teams
    ADD CONSTRAINT u_team UNIQUE (teamname);


--
-- Name: test_details unique_testname; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY test_details
    ADD CONSTRAINT unique_testname UNIQUE (testname);


--
-- Name: users associates_roleid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT associates_roleid_fkey FOREIGN KEY (roleid) REFERENCES roles(roleid);


--
-- Name: skills fk_cid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT fk_cid FOREIGN KEY (cid) REFERENCES competency(cid);


--
-- Name: associate_skills fk_pid; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_skills
    ADD CONSTRAINT fk_pid FOREIGN KEY (pid) REFERENCES proficiency(pid);


--
-- Name: associate_skills mapskill_eid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_skills
    ADD CONSTRAINT mapskill_eid_fkey FOREIGN KEY (eid) REFERENCES users(eid);


--
-- Name: associate_skills mapskill_skillid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_skills
    ADD CONSTRAINT mapskill_skillid_fkey FOREIGN KEY (skillid) REFERENCES skills(skillid);


--
-- Name: user_teams mapteams_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_teams
    ADD CONSTRAINT mapteams_cid_fkey FOREIGN KEY (cid) REFERENCES competency(cid);


--
-- Name: user_teams mapteams_eid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_teams
    ADD CONSTRAINT mapteams_eid_fkey FOREIGN KEY (eid) REFERENCES users(eid);


--
-- Name: user_teams mapteams_teamid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY user_teams
    ADD CONSTRAINT mapteams_teamid_fkey FOREIGN KEY (teamid) REFERENCES teams(teamid);


--
-- Name: associate_test_details maptestdetails_eid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_test_details
    ADD CONSTRAINT maptestdetails_eid_fkey FOREIGN KEY (eid) REFERENCES users(eid);


--
-- Name: associate_test_details maptestdetails_pid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_test_details
    ADD CONSTRAINT maptestdetails_pid_fkey FOREIGN KEY (pid) REFERENCES proficiency(pid);


--
-- Name: associate_test_details maptestdetails_skillid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_test_details
    ADD CONSTRAINT maptestdetails_skillid_fkey FOREIGN KEY (skillid) REFERENCES skills(skillid);


--
-- Name: associate_test_details maptestdetails_testid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY associate_test_details
    ADD CONSTRAINT maptestdetails_testid_fkey FOREIGN KEY (testid) REFERENCES test_details(testid);


--
-- Name: question_bank questionbank_skillid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY question_bank
    ADD CONSTRAINT questionbank_skillid_fkey FOREIGN KEY (skillid) REFERENCES skills(skillid);


--
-- PostgreSQL database dump complete
--

