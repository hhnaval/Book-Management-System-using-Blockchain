//SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

contract LibraryManagement {
    struct book
    {
        string author;
        uint edition;
        string bookname;
        string publication;
    }
    struct student
    {
        uint dept_id;
        uint fine_to_be_paid;
        uint no_of_book_lend;
    }
    mapping(uint => student) public students;
    uint [] stuids;
    mapping (uint => book) public books;
    struct lending_book
    {
        uint studentid;
    uint deptid;
    uint bookid;
    uint timestamp;
    }
    address Institution;
    address LibraryManager;
    constructor()
    {
        Institution=msg.sender;
    }
    function reg_lm(address s) public onlybyinsti(msg.sender)
    {
        LibraryManager=s;
    }
     modifier onlybyinsti(address d)
    {
        require(d==Institution);
        _;
    }
    modifier onlybylm(address d)
    {
        require(d==LibraryManager);
        _;
    }
    modifier nooflends(uint k)
    {
        require(k<=3);
        _;
    }
    function register_new_student(uint sid,uint did) public onlybyinsti(msg.sender)
    {
        stuids.push(sid);
        students[sid].dept_id=did;
        students[sid].fine_to_be_paid=0;
        students[sid].no_of_book_lend=0;
    }
    mapping (uint => lending_book) public lendedbook;
    struct return_book
    {
        uint lend_id;
        uint stu_id;
        uint deptid;
        uint bookid;
        bool damage;
        uint timestamp;
        uint fine;
    }
    mapping (uint => return_book) public returnedBooks;
    uint book_id=1;
    uint lender_id=0;
    uint return_id=0;
    function registerNewBook(string memory _author,uint _edition,string memory _bookname,string memory _publication) public onlybylm(msg.sender){
        books[book_id].author=_author;
        books[book_id].edition=_edition;
        books[book_id].bookname=_bookname;
        books[book_id].publication=_publication;
        book_id+=1;
    }

    function lending(uint _stuid,uint _deptid,uint _bookid) public onlybylm(msg.sender) nooflends(students[_stuid].no_of_book_lend) valstu(_stuid){
        lender_id+=1;
         lendedbook[lender_id].studentid=_stuid;
   lendedbook[lender_id].deptid=_deptid;
    lendedbook[lender_id].bookid=_bookid;
    lendedbook[lender_id].timestamp=block.timestamp;
    students[_stuid].no_of_book_lend+=1;
}
modifier valstu(uint id)
{
    require(valid_student(id)==true);
    _;
}
    function valid_student(uint j) private returns(bool)
    {
        uint flag=0;
        for(uint i=0;i<stuids.length;i++)
        {
            if(stuids[i]==j)
            {
                flag=1;
                return true;
            }
        }
        if (flag==0)
        {
            return false;
        }
    }
    function returnBook(uint lid,uint _stuid,uint _deptid,uint _bookid,bool _damage) public valstu(_stuid){
        return_id+=1;
        returnedBooks[return_id].lend_id=lid;
        returnedBooks[return_id].stu_id=_stuid;
        returnedBooks[return_id].deptid=_deptid;
        returnedBooks[return_id].bookid=_bookid;
        returnedBooks[return_id].damage=_damage;
        returnedBooks[return_id].timestamp=block.timestamp;
        uint f=callFine(returnedBooks[return_id].damage,returnedBooks[return_id].timestamp,returnedBooks[return_id].lend_id);
        returnedBooks[return_id].fine=f;
        students[_stuid].no_of_book_lend-=1;
        students[_stuid].fine_to_be_paid+=f;
    }

    function callFine(bool _damage,uint ts,uint h) private view returns(uint){
        uint fine=0;
        if (_damage==true){
            fine+=100;
        }
        if(ts>lendedbook[h].timestamp+10 seconds){
            fine+=200;
        }
        return fine;
    }
}
