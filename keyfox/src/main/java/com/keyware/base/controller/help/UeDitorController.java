package com.keyware.base.controller.help;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.keyware.base.controller.BaseController;
import com.keyware.base.repository.entity.help.HelpImages;
import com.keyware.base.service.itf.help.HelpImagesService;

@Controller
@RequestMapping("/ue/")
public class UeDitorController extends BaseController{
	
	@Autowired
	private HelpImagesService helpImagesService;
	
	/**
	 * 
	 * @author: 赵亚舟
	 * @Title: showImage
	 * @Description: 下载图片
	 * @param response
	 * @param id
	 * @return void
	 */
	@RequestMapping(value = "showImage",method = RequestMethod.GET)
	public void showImage(HttpServletResponse response,String fileName){
		response.setContentType("text/html; charset=UTF-8");
		InputStream fis = null;
        OutputStream os = null;
        try {
        	
        	HelpImages selectByPrimaryKey = helpImagesService.selectByPrimaryKey(fileName);
        	byte[] images = selectByPrimaryKey.getImages();
            fis = new ByteArrayInputStream(images);
            os = response.getOutputStream();
            int count = 0;
            byte[] buffer = new byte[1024 * 1024];
            while ((count = fis.read(buffer)) != -1)
                os.write(buffer, 0, count);
            
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (os != null) {
                    os.close();
                }
                if (fis != null) {
                    fis.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
	}
	
	
}
