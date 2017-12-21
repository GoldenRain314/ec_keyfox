package com.keyware.base.service.impl.drawing;

import java.util.ArrayList;
import java.util.List;

import org.bson.Document;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.keyware.base.service.drawing.FlowCountService;
import com.keyware.base.utils.MongoDBUtils;
import com.mongodb.Block;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoCursor;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 获取流量实现 Created by Administrator on 2017/12/19.
 */
@Service
public class FlowCountServiceImpl implements FlowCountService {

	@Value("${mongodb.dbName}")
	String dbName;
	@Value("${mongodb.collTotalName}")
	String collName;

	@Override
	public JSONArray selectPackageNum(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;

		List<Object[]> udp = new ArrayList<>();
		List<Object[]> ipv4 = new ArrayList<>();
		List<Object[]> tcp = new ArrayList<>();
		List<Object[]> ipv6 = new ArrayList<>();
		List<Object[]> other = new ArrayList<>();

		Block<Document> processBlock = document -> {

			Document ruleInfor = (Document) document.get("RuleInfor");
			Document matchInfor = (Document) ruleInfor.get("MatchInfor");

			Document IPV4 = (Document) matchInfor.get("13");
			Document IPV6 = (Document) matchInfor.get("17");
			Document TCP = (Document) matchInfor.get("14");
			Document UDP = (Document) matchInfor.get("15");

			// 时间
			Document culTime = (Document) document.get("CulTime");

			Object[] objects = new Object[2];
			objects[0] = culTime.get("TimeStamp");
			objects[1] = UDP.getDouble("Bytes");
			udp.add(objects);

			Object[] objects2 = new Object[2];
			objects2[0] = culTime.get("TimeStamp");
			objects2[1] = IPV4.getDouble("Bytes");
			ipv4.add(objects2);

			Object[] objects3 = new Object[2];
			objects3[0] = culTime.get("TimeStamp");
			objects3[1] = TCP.getDouble("Bytes");
			tcp.add(objects3);

			Object[] objects4 = new Object[2];
			objects4[0] = culTime.get("TimeStamp");
			objects4[1] = IPV6.getDouble("Bytes");
			ipv6.add(objects4);

			Object[] objects5 = new Object[2];
			objects5[0] = culTime.get("TimeStamp");
			objects5[1] = IPV4.getDouble("Bytes") + IPV6.getDouble("Bytes") - UDP.getDouble("Bytes")
					- TCP.getDouble("Bytes");
			other.add(objects5);
		};
		coll.find(query).sort(sort).forEach(processBlock);

		jsonObject = new JSONObject();
		jsonObject.put("name", "UDP");
		jsonObject.put("data", udp.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "IPV4");
		jsonObject.put("data", ipv4.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "TCP");
		jsonObject.put("data", tcp.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "IPV6");
		jsonObject.put("data", ipv6.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "Other");
		jsonObject.put("data", other.toArray());
		jsonArray.add(jsonObject);

		return jsonArray;
	}

	@Override
	public JSONObject selectAppScale(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);

		Double APP_MAIL_SMTP_Bytes = 0d;
		Double APP_RDP_Bytes = 0d;
		Double APP_MAIL_POP_Bytes = 0d;
		Double APP_NDPI_BITBORRENT_Bytes = 0d;
		Double APP_MYSQL_Bytes = 0d;
		Double APP_SSH_Bytes = 0d;
		Double APP_SSL_Bytes = 0d;
		Double APP_HTTP_Bytes = 0d;
		Double APP_VOIP_Bytes = 0d;
		Double APP_NDPI_EDONKEY_Bytes = 0d;

		MongoCursor<Document> cursor = coll.find(query).sort(sort).iterator();
		while (cursor.hasNext()) {
			Document document = cursor.next();
			Document ruleInfor = (Document) document.get("RuleInfor");
			Document matchInfor = (Document) ruleInfor.get("MatchInfor");

			Document APP_MAIL_SMTP = (Document) matchInfor.get("10067");
			APP_MAIL_SMTP_Bytes += APP_MAIL_SMTP.getDouble("Bytes");
			Document APP_RDP = (Document) matchInfor.get("10639");
			APP_RDP_Bytes += APP_RDP.getDouble("Bytes");
			Document APP_MAIL_POP = (Document) matchInfor.get("10101");
			APP_MAIL_POP_Bytes += APP_MAIL_POP.getDouble("Bytes");
			Document APP_NDPI_BITBORRENT = (Document) matchInfor.get("10393");
			APP_NDPI_BITBORRENT_Bytes += APP_NDPI_BITBORRENT.getDouble("Bytes");
			Document APP_MYSQL = (Document) matchInfor.get("10165");
			APP_MYSQL_Bytes += APP_MYSQL.getDouble("Bytes");
			Document APP_SSH = (Document) matchInfor.get("10061");
			APP_SSH_Bytes += APP_SSH.getDouble("Bytes");
			Document APP_SSL = (Document) matchInfor.get("10638");
			APP_SSL_Bytes += APP_SSL.getDouble("Bytes");
			Document APP_HTTP = (Document) matchInfor.get("10637");
			APP_HTTP_Bytes += APP_HTTP.getDouble("Bytes");
			Document APP_VOIP = (Document) matchInfor.get("10631");
			APP_VOIP_Bytes += APP_VOIP.getDouble("Bytes");
			Document APP_NDPI_EDONKEY = (Document) matchInfor.get("10221");
			APP_NDPI_EDONKEY_Bytes += APP_NDPI_EDONKEY.getDouble("Bytes");
		}

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_MAIL_SMTP");
		jsonObject.put("value", APP_MAIL_SMTP_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_RDP");
		jsonObject.put("value", APP_RDP_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_MAIL_POP");
		jsonObject.put("value", APP_MAIL_POP_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_NDPI_BITBORRENT");
		jsonObject.put("value", APP_NDPI_BITBORRENT_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_MYSQL");
		jsonObject.put("value", APP_MYSQL_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_SSH");
		jsonObject.put("value", APP_SSH_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_SSL");
		jsonObject.put("value", APP_SSL_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_HTTP");
		jsonObject.put("value", APP_HTTP_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_VOIP");
		jsonObject.put("value", APP_VOIP_Bytes);
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "APP_NDPI_EDONKEY");
		jsonObject.put("value", APP_NDPI_EDONKEY_Bytes);
		jsonArray.add(jsonObject);

		JSONObject data = new JSONObject();
		data.put("name", "应用比例");
		data.put("type", "pie");
		data.put("radius", "55%");
		data.put("center", "['50%', '60%']");
		data.put("data", jsonArray);

		return data;
	}

	@Override
	public JSONArray connectionInfor(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);
		List<Object[]> udp = new ArrayList<>();
		List<Object[]> tcp = new ArrayList<>();
		List<Object[]> other = new ArrayList<>();
		Block<Document> processBlock = document -> {
			Object[] objects = new Object[3];
			Document aa = (Document) document.get("CulTime");
			objects[0] = aa.get("TimeStamp").toString();
			Document bb = (Document) document.get("ConnectInfor");
			objects[1] = bb.getDouble("ConnectNum_UDP");
			objects[2] = "UDP";
			udp.add(objects);

			Object[] objects2 = new Object[3];
			objects2[0] = aa.get("TimeStamp");
			objects2[1] = bb.getDouble("ConnectNum_TCP");
			objects2[2] = "TCP";
			tcp.add(objects2);

			Object[] objects3 = new Object[3];
			objects3[0] = aa.get("TimeStamp");
			objects3[1] = bb.getDouble("ConnectNum_Total") - bb.getDouble("ConnectNum_TCP")
					- bb.getDouble("ConnectNum_UDP") + bb.getDouble("ConnectNum_TimeOut");
			objects3[2] = "Others";
			other.add(objects3);

		};
		coll.find(query).sort(sort).forEach(processBlock);

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;

		jsonObject = new JSONObject();
		jsonObject.put("name", "UDP");
		jsonObject.put("data", udp.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "TCP");
		jsonObject.put("data", tcp.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "Other");
		jsonObject.put("data", other.toArray());
		jsonArray.add(jsonObject);

		return jsonArray;
	}

	@Override
	public JSONArray boundFlowPackageNum(String date) {

		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);
		List<Object[]> in = new ArrayList<>();
		List<Object[]> out = new ArrayList<>();
		Block<Document> processBlock = document -> {
			Object[] objects = new Object[2];
			Document culTime = (Document) document.get("CulTime");
			objects[0] = culTime.get("TimeStamp").toString();

			Document intraNet = (Document) document.get("IntraNet");
			Document toIntra = (Document) intraNet.get("ToIntra");
			objects[1] = toIntra.get("PacketNum");	
			in.add(objects);

			Object[] objects2 = new Object[2];
			objects2[0] = culTime.get("TimeStamp");
			Document fromIntra = (Document) intraNet.get("FromIntra");
			objects2[1] = fromIntra.getDouble("PacketNum");
			out.add(objects2);
		};
		coll.find(query).sort(sort).forEach(processBlock);

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;

		jsonObject = new JSONObject();
		jsonObject.put("name", "IN");
		jsonObject.put("data", in.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "OUT");
		jsonObject.put("data", out.toArray());
		jsonArray.add(jsonObject);

		return jsonArray;
	}

}
