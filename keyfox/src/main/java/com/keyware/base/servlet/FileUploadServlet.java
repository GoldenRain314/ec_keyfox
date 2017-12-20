package com.keyware.base.servlet;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.output.ByteArrayOutputStream;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.google.gson.JsonObject;
import com.keyware.base.repository.entity.help.HelpImages;
import com.keyware.base.service.itf.help.HelpImagesService;
import com.keyware.utils.IdGenerator;

/**
 * Servlet implementation class fileUploadServlet
 */

public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public FileUploadServlet() {
        super();
    }
    
    private HelpImagesService helpImagesService;
    
    private ApplicationContext applicationContext; 
	
    public void init(ServletConfig config) throws ServletException {  
 	    super.init(config);  
 	    applicationContext = WebApplicationContextUtils.getRequiredWebApplicationContext(this.getServletContext());  
 	    helpImagesService = (HelpImagesService) applicationContext.getBean("helpImagesService");  
    }
    

    /**
     * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    }

    /**
     * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        request.setCharacterEncoding("utf-8");  //设置编码  
        
        //获得磁盘文件条目工厂  
        DiskFileItemFactory factory = new DiskFileItemFactory();  
        //获取文件需要上传到的路径  
        String path = "C:/kdimages";  
          
        //如果没以下两行设置的话，上传大的 文件 会占用 很多内存，  
        //设置暂时存放的 存储室 , 这个存储室，可以和 最终存储文件 的目录不同  
        /** 
         * 原理 它是先存到 暂时存储室，然后在真正写到 对应目录的硬盘上，  
         * 按理来说 当上传一个文件时，其实是上传了两份，第一个是以 .tem 格式的  
         * 然后再将其真正写到 对应目录的硬盘上 
         */  
        factory.setRepository(new File(path));  
        //设置 缓存的大小，当上传文件的容量超过该缓存时，直接放到 暂时存储室  
        factory.setSizeThreshold(1024*1024) ; 
        //高水平的API文件上传处理  
        ServletFileUpload upload = new ServletFileUpload(factory);
        
        //可以上传多个文件  
        try {
			List<FileItem> list = (List<FileItem>)upload.parseRequest(request);
			
			for(FileItem item : list){  
                //获取表单的属性名字  
                String name = item.getFieldName();  
                  
                //如果获取的 表单信息是普通的 文本 信息  
                if(item.isFormField()) {                     
                    //获取用户具体输入的字符串 ，名字起得挺好，因为表单提交过来的是 字符串类型的  
                    String value = item.getString() ;  
                      
                    request.setAttribute(name, value);  
                }  
                //对传入的非 简单的字符串进行处理 ，比如说二进制的 图片，电影这些  
                else  {  
                    /** 
                     * 以下三步，主要获取 上传文件的名字 
                     */  
                    //获取路径名  
                    String value = item.getName() ;  
                    //索引到最后一个反斜杠  
                    int start = value.lastIndexOf("\\");  
                    //截取 上传文件的 字符串名字，加1是 去掉反斜杠，  
                    String filename = value.substring(start+1);  
                    
                    int lastIndexOf = filename.lastIndexOf(".");
                    
                    String substring = filename.substring(lastIndexOf);
                    
                      
                    ByteArrayOutputStream outStream = new ByteArrayOutputStream();
                    InputStream in = item.getInputStream() ;  
                      
                    int length = 0 ;  
                    byte [] buf = new byte[1024] ;  
                      
                    // in.read(buf) 每次读到的数据存放在   buf 数组中  
                    while( (length = in.read(buf) ) != -1) {  
                        outStream.write(buf,0,length);
                    }
                    
                    //将图片保存到数据库
                    HelpImages record = new HelpImages();
                    record.setId(IdGenerator.uuid32());
                    record.setImages(outStream.toByteArray());
					helpImagesService.insertSelective(record );
					outStream.close();
                    in.close();  
                    
                    String fileName = record.getId()+substring;
					request.setAttribute(name, fileName);  
                    
                    JsonObject jsonObject = new JsonObject();
                    jsonObject.addProperty("state", "SUCCESS");
                    jsonObject.addProperty("size", item.getSize());
                    jsonObject.addProperty("title", fileName);
                    jsonObject.addProperty("type", substring);
                    jsonObject.addProperty("original", fileName);
                    
                    jsonObject.addProperty("url", request.getContextPath()+"/ue/showImage?fileName="+record.getId());
                    response.getOutputStream().print(jsonObject.toString());
                } 
            }  
		} catch (FileUploadException e) {
			e.printStackTrace();
		} 
        
        
    }

}