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
    mapping (uint => book) public books;
    struct lending_book
    {
        uint studentid;
    uint deptid;
    uint bookid;
    uint timestamp;
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
    // bytes public author;
    // uint public edition;
    // bytes public bookname;
    // bytes public publication;
    // uint public studentid;
    // uint public deptid;
    
    // uint public timestamp;
    // bool public damage;
    // uint public fine;
    uint book_id=1;
    uint lender_id=0;
    uint return_id=0;
    function registerNewBook(string memory _author,uint _edition,string memory _bookname,string memory _publication) public{
        books[book_id].author=_author;
        books[book_id].edition=_edition;
        books[book_id].bookname=_bookname;
        books[book_id].publication=_publication;
        book_id+=1;
    }

    function lending(uint _stuid,uint _deptid,uint _bookid) public{
        lender_id+=1;
         lendedbook[lender_id].studentid=_stuid;
   lendedbook[lender_id].deptid=_deptid;
    lendedbook[lender_id].bookid=_bookid;
    lendedbook[lender_id].timestamp=block.timestamp;
}
    function returnBook(uint lid,uint _stuid,uint _deptid,uint _bookid,bool _damage) public{
        return_id+=1;
        returnedBooks[return_id].lend_id=lid;
        returnedBooks[return_id].stu_id=_stuid;
        returnedBooks[return_id].deptid=_deptid;
        returnedBooks[return_id].bookid=_bookid;
        returnedBooks[return_id].damage=_damage;
        returnedBooks[return_id].timestamp=block.timestamp;
        uint f=callFine(returnedBooks[return_id].damage,returnedBooks[return_id].timestamp,returnedBooks[return_id].lend_id);
        returnedBooks[return_id].fine=f;
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
