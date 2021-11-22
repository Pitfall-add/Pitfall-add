package com.ing.service;

import com.ing.pojo.Books;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BookService {
    public List<Books> queryAllBooks();

    public int deleteBook(int bookID);

    public int insertBook(Books books);

    public int updateBook(Books books);

    public Books queryBookById(int bookID);
}
