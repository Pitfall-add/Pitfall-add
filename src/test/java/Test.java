import com.ing.service.BookService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

public class Test {
    @org.junit.Test
    public void test(){
        ApplicationContext context=new ClassPathXmlApplicationContext("applicationContext.xml");
        BookService service= (BookService) context.getBean("bookServiceImpl");
        System.out.println(service.queryBookById(1));
    }
}
