package com.keyware.utils;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;

public class Excl {
	/**
	 * 
	 * @Title: getCellValue
	 * @Description: 获取cell值
	 * @param cell
	 * @return
	 * @author 赵亚舟
	 * @return String
	 */
	public static String getCellValue(Cell cell) {
		String cellValue = "";
		if(cell == null)
			return cellValue;
		switch (cell.getCellType()) {
			case Cell.CELL_TYPE_STRING:     // 文本  
	            cellValue = cell.getRichStringCellValue().getString();  
	            break;  
	        case Cell.CELL_TYPE_NUMERIC:    // 数字、日期  
	            if (DateUtil.isCellDateFormatted(cell)) {  
	                cellValue = DateUtils.formatDateTime(cell.getDateCellValue());  
	            } else {  
	                cell.setCellType(Cell.CELL_TYPE_STRING);  
	                cellValue = String.valueOf(cell.getRichStringCellValue().getString());  
	            }  
	            break;  
	        case Cell.CELL_TYPE_BOOLEAN:    // 布尔型  
	            cellValue = String.valueOf(cell.getBooleanCellValue());  
	            break;  
	        case Cell.CELL_TYPE_BLANK: // 空白  
	            cellValue = cell.getStringCellValue();  
	            break;  
	        case Cell.CELL_TYPE_ERROR: // 错误  
	            cellValue = "错误";  
	            break;  
	        case Cell.CELL_TYPE_FORMULA:    // 公式  
	            // 得到对应单元格的公式  
	            //cellValue = cell.getCellFormula();  
	            // 得到对应单元格的字符串  
	            cell.setCellType(Cell.CELL_TYPE_STRING);  
	            cellValue = String.valueOf(cell.getRichStringCellValue().getString());  
	            break;  
	        default:  
	            cellValue = ""; 
			}
		return cellValue;
	}
}
