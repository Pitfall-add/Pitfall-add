package com.ing.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ing.pojo.Books;
import com.ing.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/books")
public class BookController {

    /*
    * get表示获取数据
    * post表示保存数据
    * put表示修改数据
    * delete表示删除数据
    * */

    @Autowired
    @Qualifier("bookServiceImpl")
    BookService bookService;

    @RequestMapping("/allBooks")
    @ResponseBody
    public PageInfo queryAllBooks(@RequestParam(value = "pn",defaultValue = "1")int pn)
    {
        PageHelper.startPage(pn,5);//表示一页有五条数据
        //startPage后面的紧跟的查询就是分页查询
        List<Books> list=bookService.queryAllBooks();
        //封装了详细的分页信息，包括我们查询出来的数据，传入显示页数
        PageInfo pageInfo=new PageInfo(list);
        return pageInfo;
    }

    //保存员工数据
    @RequestMapping(value = "/addBook",method = RequestMethod.POST)
    @ResponseBody
    public Books insertBook(Books books)
    {
        bookService.insertBook(books);
        return books;
    }

    //根据id去查找需要修改数据的信息并返回json
    @RequestMapping(value = "/queryBook/{bookId}",method = RequestMethod.GET)
    @ResponseBody
    public Books queryBookById(@PathVariable("bookId")int bookId)
    {
        Books books=bookService.queryBookById(bookId);
        return books;
    }

    //ajax请求进行修改数据
    @RequestMapping(value = "/updateBook",method = RequestMethod.PUT)
    @ResponseBody
    public Boolean updateBook(Books books)
    {
        //System.out.println("需要修改的数据："+books);
        int n=bookService.updateBook(books);
        return n>0?true:false;
    }

    //ajax请求进行删除数据
    @RequestMapping(value = "/deleteBook/{bookId}",method = RequestMethod.DELETE)
    @ResponseBody
    public boolean deleteBook(@PathVariable("bookId")int id)
    {
        int n=bookService.deleteBook(id);
        return n>0?true:false;
    }


    //进行批量删除
    @RequestMapping(value = "/deleteBookS/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Boolean deleteBookS(@PathVariable("ids")String ids)
    {
        int counts=0;
        String[] str=ids.split(",");
        //System.out.println(str[0]+" "+str[1]);
        for(int i=0;i<str.length;i++)
        {
            int n=bookService.deleteBook(Integer.parseInt(str[i]));
            counts+=n;
        }
        return counts>0?true:false;
    }
}
