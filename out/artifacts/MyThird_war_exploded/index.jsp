<%--
  Created by IntelliJ IDEA.
  User: kinga
  Date: 2021/11/1
  Time: 11:43
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>进入系统</title>
    <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js"></script>
    <!-- 新 Bootstrap 核心 CSS 文件 -->
    <link href="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
    <script src="https://cdn.staticfile.org/jquery/2.1.1/jquery.min.js"></script>

    <!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
    <script src="https://cdn.staticfile.org/twitter-bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            var curPage;
            var totalPage;
            //console.log("你好Ajax");
            to_page(1);//显示首页内容
            //利用ajax实现
                function to_page(pn) {
                    $.ajax({
                        url:"${pageContext.request.contextPath}/books/allBooks",
                        data:"pn="+pn,
                        type:"GET",
                        success:function (result) {
                            console.log(result);
                            curPage=result.pageNum;//当删除或者修改数据的定位到当前位置，表示当前页
                            totalPage=result.pages;//最后一页，当新增数据后，跳转到最后一页
                            page_table_info(result);//调用打印数据的函数
                            page_info(result);//调用分页信息函数
                            navs_info(result);//调用分页条信息函数
                        }
                    });
                }
            //显示table中信息
            function page_table_info(result) {
                $("#content").empty();//清空之前有的数据，显示新请求的数据
                var books=result.list;
                $.each(books,function(index,item){
                    var cheBtn=$("<input type='checkbox'/>");
                    var bookId=$("<td></td>").append(item.bookID);
                    var bookName=$("<td></td>").append(item.bookName);
                    var bookCounts=$("<td></td>").append(item.bookCounts);
                    var detail=$("<td></td>").append(item.detail);
                    var ediBtn=$("<button id='update_btn'></button>").addClass("btn btn-primary btn-sm").attr("value",item.bookID)
                        .append("<span></span>").addClass("glyphicon glyphicon-pencil").append("编辑");
                    var delBtn=$("<button id='delete_btn'></button>").addClass("btn btn-danger btn-sm").attr("value",item.bookID)
                        .append("<span></span>").addClass("glyphicon glyphicon-trash").append("删除");
                    var btnTab=$("<td></td>").append(delBtn).append(" ").append(ediBtn);
                    $("<tr></tr>").append(cheBtn)
                    .append(bookId)
                    .append(bookName)
                    .append(bookCounts)
                    .append(detail).append(btnTab).appendTo("#content");
                });
            }

            //显示分页信息
            function page_info(result) {
                $("#page_info_area").empty();//清空数据
                $("#page_info_area").append("当前"+result.pageNum+"页,总"
                    +result.pages
                    +"页,总"
                    +result.total
                    +"条记录");
            }
            //显示分页条数据
            function navs_info(result) {
                $("#page_nav_area").empty();//清空数据
                var uls=$("<ul></ul>").addClass("pagination");
                //构建元素
                var firstPageLi=$("<li></li>").append($("<a>首页</a>")).attr("href","#");
                var prePageLi=$("<li></li>").append($("<a>&laquo;</a>"));
                //判断是否有前一页，如果没有前一页就不能点击前一页或首页按钮 hasPreviousPage为false表示没有前一页了
                if(result.hasPreviousPage==false)
                {
                    firstPageLi.addClass("disabled");
                    prePageLi.addClass("disabled");
                }else{
                    //为元素添加点击翻页事件
                    firstPageLi.click(function () {
                        to_page(1);
                    });
                    prePageLi.click(function () {
                        to_page(result.pageNum-1);//当前页减一就是上一页的数据
                    });
                }
                //构建元素
                var nextPageLi=$("<li></li>").append($("<a>&raquo;</a>"));
                var lastPageLi=$("<li></li>").append($("<a>末页</a>")).attr("href","#");
                //判断是否有后一页，如果没有后一页就不能点击后一页或未页按钮 hasNextPage为false表示没有后一页了
                if(result.hasNextPage==false)
                {
                    nextPageLi.addClass("disabled");
                    lastPageLi.addClass("disabled");
                }else {
                    //为元素添加点击翻页事件
                    lastPageLi.click(function () {
                        to_page(result.pages);//pages表示最后一页
                    });
                    nextPageLi.click(function () {
                        to_page(result.pageNum+1);//当前页加一就是下一页的数据
                    });
                }
                //在ul中先添加首页和前一页的标签
                uls.append(firstPageLi).append(prePageLi);
                //分页条的数字信息1 2 3...
                $.each(result.navigatepageNums,function (index,item) {
                    var numLis=$("<li></li>").append($("<a></a>").append(item));

                    //当前页
                    if(result.pageNum==item)
                    {
                        numLis.addClass("active");
                    }
                    //点击事件，当点击分页条数据中任何按钮时，去到多对应的页
                    //在点击之前我们清空之前的请求，不然会有数据重叠
                    numLis.click(function () {
                        to_page(item);
                    });
                    //在ul中添加显示分页条数字
                    uls.append(numLis);
                });
                //在ul中添加下一页和尾页
                uls.append(nextPageLi).append(lastPageLi);
                //把nav添加到对用的盒子里;
                $("#page_nav_area").append(uls);
            }

            //点击新增按钮，弹出模态框
            $("#book_add_modal_btn").click(function(){
                $("#bookAddModal").modal({
                    backdrop:"static"
                });
            });
            //点击保存，进行添加数据
            $("#add_book_btn").click(function () {
                //1.模态框中填写的表达数据提交给服务器进行保存
                //2.发送ajax请求保存书籍

                $.ajax({
                    url:"${pageContext.request.contextPath}/books/addBook",
                    type: "POST",
                    data:$("#bookAddModal form").serialize(),
                    success:function (result) {
                        $("#bookAddModal").modal('hide');
                        //清除数据，当我们添加数据后不刷新再次点击添加会有之前添加的数据保留，所以我们需要清除一下
                        $("#bookAddModal form")[0].reset();
                        to_page(totalPage);
                    }
                });
            });

            //点击编辑按钮进入到修改界面的模态框
            //我们是按钮创建之前就已经绑定了click，所以绑定不上
            //1)可以在创建按钮的时候绑定    2)绑定点击.live()
            //jqeury最新版没有live，使用on代替
            $(document).on("click","#update_btn",function () {
                $("#bookUpdateModal").modal({
                    backdrop: "static"
                });
                //拿到需要修改的数据的id
                var bid=$(this).val();
                //点击更改后进行数据发送修改的ajax请求
                $.ajax({
                    url:"${pageContext.request.contextPath}/books/queryBook/"+bid,
                    type:"GET",
                    success:function (result) {
                        //console.log(result.bookID);
                        $("#input_update_bookID").val(result.bookID);
                        $("#input_update_bookName").val(result.bookName);
                        $("#input_update_bookCounts").val(result.bookCounts);
                        $("#input_update_detail").val(result.detail);
                    }
                });

            });

                //点击编辑模态框中的更新按钮，实现数据的更新
            $("#update_book_btn").click(function () {
                $.ajax({
                    url:"${pageContext.request.contextPath}/books/updateBook",
                    type:"POST",
                    data:$("#bookUpdateModal form").serialize()+"&_method=PUT",
                    success:function () {
                        //点击更新之后关闭模态框
                        $("#bookUpdateModal").modal('hide');
                        to_page(curPage);//去到当前页，也就是我们点击修改的地方
                    }

                });
            });

            //点击删除按钮发送ajax进行删除数据
            $(document).on("click","#delete_btn",function () {
                var id=$(this).val();//拿到需要删除的数据的id
                // alert(id);
                if(confirm("确定删除书籍编号为 "+id+" 的书籍吗？")){//表示是否确定删除当前数据，是就发送ajax请求进行删除
                    $.ajax({
                        url:"${pageContext.request.contextPath}/books/deleteBook/"+id,
                        type:"DELETE",
                        success:function (result) {
                            // alert(result);
                            to_page(curPage);//去到我们点击删除的那个页面
                        }
                    });
                }

            });

            //批量删除
            // 完成全选和全不选按钮
            $("#check_all").click(function () {
                //使用attr获取checked是undefined
                // 我们这些dom原生的属性，attr获取的是自定义的属性
                // 使用prop修改和读取dom原生属性的值
                $(".check_item").prop("checked", $(this).prop("checked"));//进行绑定
            });

            //表示进行分页时，当前页有n条数据，当我们全选这n条数据时间，全选的复选框也选上，有一条没选则全选的复选框不选上
            //假设当前页为5条数据
            $(document).on("click",".check_item",function () {
                //判断当前选中的是否有5条数据
                var flag=$(".check_item:checked").length==5;
                $("#check_all").prop("checked",flag);
            });

            //点击批量删除可以删除单个或者多个
            $("#delete_allBook").click(function () {
                var ids="";
                $.each($(".check_item:checked"),function () {
                    //this
                    ids+=$(this).parents("tr").find("td:eq(1)").text()+",";

                });
                //ids最后一个会是逗号，所以我们要把最后一个逗号去掉,赋值给新定义的变量
                var Nids=ids.substring(0,ids.length-1);

               if(Nids.length>0)
               {
                   if(confirm("确定删除编号为["+Nids+"]的书籍？"))
                   {
                       //alert("success");
                       // 发送ajax请求进行批量删除
                       $.ajax({
                           url:"${pageContext.request.contextPath}/books/deleteBookS/"+Nids,
                           type:"DELETE",
                           success:function (result) {
                               //alert(result);
                               // shuaxin();
                           }

                       });
                   }
               }else{
                   alert("请选择你需要删除的书籍编号!");
               }

            });

        });

    </script>
</head>
<body>
<!-- 修改的模态框 -->
<div class="modal fade" id="bookUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">修改书籍</h4>
            </div>
            <div class="modal-body">
                <!-- 模态框中的表单-->
                <form class="form-horizontal">
                    <input type="hidden" class="form-control" name="bookID" id="input_update_bookID" placeholder="书籍编号">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍名</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="bookName" id="input_update_bookName" placeholder="书籍名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍数量</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"  name="bookCounts" id="input_update_bookCounts" placeholder="书籍数量">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍详情</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"  name="detail" id="input_update_detail" placeholder="书籍详情">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="update_book_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 添加数据的模态框 -->
<div class="modal fade" id="bookAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加书籍</h4>
            </div>
            <div class="modal-body">
                <!-- 模态框中的表单-->
                <form class="form-horizontal">
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍名</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control" name="bookName" id="input_add_bookName" placeholder="书籍名">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍数量</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"  name="bookCounts" id="input_add_bookCounts" placeholder="书籍数量">
                        </div>
                    </div>
                    <div class="form-group">
                        <label  class="col-sm-2 control-label">书籍详情</label>
                        <div class="col-sm-10">
                            <input type="text" class="form-control"  name="detail" id="input_add_detail" placeholder="书籍详情">
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="add_book_btn">保存</button>
            </div>
        </div>
    </div>
</div>


<!-- 搭建显示页面 -->
<div class="container">
    <!-- 标题 -->
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!-- 按钮 -->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="book_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="delete_allBook">删除</button>
        </div>
    </div>
    <!-- 显示表格信息 -->
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover">
                <thead>
                <tr>
                    <th>
                        <input type="checkbox" id="check_all">
                    </th>
                    <th>书籍编号</th>
                    <th>书籍名</th>
                    <th>书籍数量</th>
                    <th>详细信息</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody id="content">

                </tbody>
            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页文字信息--%>
        <div class="col-md-7" id="page_info_area"></div>
        <%--分页条信息--%>
        <div class="col-md-5" >
            <nav aria-label="Page navigation" id="page_nav_area"></nav>
        </div>
    </div>
</div>
</body>
</html>
