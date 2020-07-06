

<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html>
<%@ include file = "../../include/head.jsp" %>
<style>
    .fileDrop {
        width: 100%;
        height: 200px;
        border: 2px dotted #0b58a2;
    }
</style>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

  <!-- Navbar -->
  <%@ include file = "../../include/main_header.jsp" %>
  <!-- /.navbar -->

  <!-- Main Sidebar Container -->
  <%@ include file = "../../include/left_column.jsp" %>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <div class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1 class="m-0 text-dark">Starter Page</h1>
          </div><!-- /.col -->
          <div class="col-sm-6">
            <ol class="breadcrumb float-sm-right">
              <li class="breadcrumb-item"><a href="#">Home</a></li>
              <li class="breadcrumb-item active">Starter Page</li>
            </ol>
          </div><!-- /.col -->
        </div><!-- /.row -->
      </div><!-- /.container-fluid -->
    </div>
    <!-- /.content-header -->

    <!-- Main content -->
    <div class="content">
      <div class="container-fluid">
					<div class="col-lg-12">
						<form role="form" id="writeForm" method="post"
							action="${path}/article/paging/search/modify">
							<div class="card ">
								<div class="card-header with-border">
									<h3 class="box-title">게시글 작성</h3>
								</div>
								<div class="card-body">
									<input type="hidden" name="article_no" value="${article.article_no}">
									<input type="hidden" name="page" value="${searchCriteria.page}">
								    <input type="hidden" name="perPageNum" value="${searchCriteria.perPageNum}">
								    <input type="hidden" name="searchType" value="${searchCriteria.searchType}">
								    <input type="hidden" name="keyword" value="${searchCriteria.keyword}">
									<div class="form-group">
										<label for="title">제목</label> <input class="form-control"
											id="title" name="title" placeholder="제목을 입력해주세요"
											value="${article.title}">
									</div>
									<div class="form-group">
										<label for="content">내용</label>
										<textarea class="form-control" id="content" name="content"
											rows="30" placeholder="내용을 입력해주세요" style="resize: none;">${article.content}</textarea>
									</div>
									<div class="form-group">
										<label for="writer">작성자</label> <input class="form-control"
											id="writer" name="writer" value="${article.writer}" readonly>
									</div>
									<div class="form-group">
										<div class="fileDrop">
											<br /> <br /> <br /> <br />
											<p class="text-center">
												<i class="fa fa-paperclip"></i> 첨부파일을 드래그해주세요.
											</p>
										</div>
									</div>
									<div class="box-footer">
		                           		<ul class="mailbox-attachments clearfix uploadedList"></ul>
		                        	</div>
								</div>
								
								<div class="card-footer">
									<button type="button" class="btn btn-primary">
										<i class="fa fa-list"></i> 목록
									</button>
									<div class="float-right">
										<button type="button" class="btn btn-warning cancelBtn">
											<i class="fa fa-trash"></i> 취소
										</button>
										<button type="submit" class="btn btn-success modBtn">
											<i class="fa fa-save"></i> 수정 저장
										</button>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
  </div>
  <!-- /.content-wrapper -->

  <!-- Control Sidebar -->
  <aside class="control-sidebar control-sidebar-dark">
    <!-- Control sidebar content goes here -->
    <div class="p-3">
      <h5>Title</h5>
      <p>Sidebar content</p>
    </div>
  </aside>
  <!-- /.control-sidebar -->

  <!-- Main Footer -->
  <%@ include file = "../../include/main_footer.jsp" %>
</div>
<!-- ./wrapper -->

<!-- REQUIRED SCRIPTS -->
 <%@ include file = "../../include/plugin_js.jsp" %>
<script>
$(document).ready(function () {
	var article_no = ${article.article_no}; // 현재 게시글 번호
    var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html()); // 이미지 Template
    var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());   // 일반파일 Template
    /*================================================게시판 업로드 첨부파일 추가관련===================================*/
    // 전체 페이지 파일 끌어 놓기 기본 이벤트 방지 : 지정된 영역외에 파일 드래그 드랍시 페이지 이동방지
    $(".content-wrapper").on("dragenter dragover drop", function (event) {
        event.preventDefault();
    });
    // 파일 끌어 놓기 기본 이벤트 방지
    $(".fileDrop").on("dragenter dragover", function (event) {
        event.preventDefault();
    });
    // 파일 드랍 이벤트 : 파일 전송 처리
    $(".fileDrop").on("drop", function (event) {
        event.preventDefault();
        var files = event.originalEvent.dataTransfer.files;
        var file = files[0];
        var formData = new FormData();
        formData.append("file", file);
        $.ajax({
            url: "/springMVCpage/file/upload",
            data: formData,
            dataType: "text",
            processData: false,
            contentType: false,
            type: "POST",
            success: function (data) {
                // 파일정보 가공
                var fileInfo = getFileInfo(data);
                // 이미지 파일일 경우
                if (fileInfo.fullName.substr(12, 2) == "s_") {
                    var html = templatePhotoAttach(fileInfo);
                    // 이미지 파일이 아닐경우
                } else {
                    html = templateFileAttach(fileInfo);
                }
                // 목록에 출력
                $(".uploadedList").append(html);
            }
        });
    });
    // 수정 처리시 파일 정보도 함께 처리
    $("#writeForm").submit(function (event) {
        event.preventDefault();
        var that = $(this);
        var str = "";
        $(".uploadedList .delBtn").each(function (index) {
            str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>"
        });
        that.append(str);
        that.get(0).submit();
    });
    // 파일 삭제 버튼 클릭 이벤트
    $(document).on("click", ".delBtn", function (event) {
        event.preventDefault();
        if (confirm("삭제하시겠습니까? 삭제된 파일은 복구할 수 없습니다.")) {
            var that = $(this);
            $.ajax({
                url: "/springMVCpage/file/delete/" + article_no,
                type: "post",
                data: {fileName:$(this).attr("href")},
                dataType: "text",
                success: function (result) {
                    if (result == "DELETED") {
                        alert("삭제되었습니다.");
                        that.parents("li").remove();
                    }
                }
            });
        }
    });
    /*================================================게시판 업로드 첨부파일 목록관련===================================*/
    $.getJSON("/springMVCpage/file/list/" + article_no, function (list) {
        $(list).each(function () {
            var fileInfo = getFileInfo(this);
            // 이미지 파일일 경우
            if (fileInfo.fullName.substr(12, 2) == "s_") {
                var html = templatePhotoAttach(fileInfo);
                // 이미지 파일이 아닐 경우
            } else {
                html = templateFileAttach(fileInfo);
            }
            $(".uploadedList").append(html);
        })
    });
    
    var formObj = $("form[role='form']");
    console.log(formObj);

    

    $(".cancelBtn").on("click", function () {
        history.go(-1);
    });

    $(".listBtn").on("click", function () {
        self.location = "${path}/article/paging/search/list?page=${searchCriteria.page}"
            + "&perPageNum=${searchCriteria.perPageNum}"
            + "&searchType=${searchCriteria.searchType}"
            + "&keyword=${searchCriteria.keyword}";
    });

});
</script>
<script type="text/javascript" src="/springMVCpage/resources/dist/js/upload.js"></script>

<%--첨부파일 하나의 영역--%>
<%--이미지--%>
<script id="templatePhotoAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="uploadImages"><i class="fas fa-camera"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
<%--일반 파일--%>
<script id="templateFileAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name"><i class="fas fa-paperclip"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
</body>
</html>

