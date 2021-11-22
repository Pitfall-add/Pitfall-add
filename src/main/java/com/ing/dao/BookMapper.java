package com.ing.dao;

import com.ing.pojo.Books;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface BookMapper {
    public List<Books> queryAllBooks();

    public int deleteBook(@Param("bookId")int bookID);

    public int insertBook(Books books);

    public int updateBook(Books books);

    public Books queryBookById(@Param("bookId")int bookID);
}
