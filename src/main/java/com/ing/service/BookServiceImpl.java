package com.ing.service;

import com.ing.dao.BookMapper;
import com.ing.pojo.Books;

import java.util.List;

public class BookServiceImpl implements BookService{

    private BookMapper bookMapper;

    public void setBookMapper(BookMapper bookMapper) {
        this.bookMapper = bookMapper;
    }

    @Override
    public List<Books> queryAllBooks() {
        return bookMapper.queryAllBooks();
    }

    @Override
    public int deleteBook(int bookID) {
        return bookMapper.deleteBook(bookID);
    }

    @Override
    public int insertBook(Books books) {
        return bookMapper.insertBook(books);
    }

    @Override
    public int updateBook(Books books) {
        return bookMapper.updateBook(books);
    }

    @Override
    public Books queryBookById(int bookID) {
        return bookMapper.queryBookById(bookID);
    }
}
