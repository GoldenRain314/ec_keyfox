package com.keyware.base.service.impl.drawing;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
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
	public JSONArray selectAppScale(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);

		Map<String, Double> map = new HashedMap();

		MongoCursor<Document> cursor = coll.find(query).sort(sort).iterator();
		while (cursor.hasNext()) {
			Document document = cursor.next();
			Document ruleInfor = (Document) document.get("RuleInfor");
			Document matchInfor = (Document) ruleInfor.get("MatchInfor");
			
//			for(Document document2 : matchInfor) {
//				String name = document2.getString("Name");
//				Double bytes = document2.getDouble("Bytes");
//				
//			}
			
		}

	

		return null;
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

	@Override
	public JSONArray boundFlowBytes(String date) {
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
			objects[1] = toIntra.get("PacketBytes");
			in.add(objects);

			Object[] objects2 = new Object[2];
			objects2[0] = culTime.get("TimeStamp");
			Document fromIntra = (Document) intraNet.get("FromIntra");
			objects2[1] = fromIntra.getDouble("PacketBytes");
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

	@Override
	public JSONArray exceptionFlow(String date) {
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
			Document toIntra = (Document) intraNet.get("BothIntra");
			objects[1] = toIntra.get("PacketBytes");
			in.add(objects);

			Object[] objects2 = new Object[2];
			objects2[0] = culTime.get("TimeStamp");
			Document fromIntra = (Document) intraNet.get("NoIntra");
			objects2[1] = fromIntra.getDouble("PacketBytes");
			out.add(objects2);

		};
		coll.find(query).sort(sort).forEach(processBlock);

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject;

		jsonObject = new JSONObject();
		jsonObject.put("name", "双向内部IP");
		jsonObject.put("data", in.toArray());
		jsonArray.add(jsonObject);

		jsonObject = new JSONObject();
		jsonObject.put("name", "双向外部IP");
		jsonObject.put("data", out.toArray());
		jsonArray.add(jsonObject);

		return jsonArray;
	}

	@Override
	public JSONArray packageIPNum(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);

		Map<String, List<Object[]>> reMap = new HashedMap();
		Map<String, List<Object[]>> refromMap = new HashedMap();
		
		Block<Document> processBlock = document -> {
			
			Document culTime = (Document) document.get("CulTime");
			//获取时间
			String dateString = culTime.get("TimeStamp").toString();
			
			//上一条数据
			Map<String,Double> numMap = getMap(coll,dateString,"To_Num");
			Map<String,Double> fromMap = getMap(coll,dateString,"From_Num");
			
			Document intraNet = (Document) document.get("IntraNet");
			//全部数据
			List<Document> lists = intraNet.get("Packet",new ArrayList());
			
			for(Document documents : lists) {
				
				Object[] objects = new Object[2];
				objects[0] = dateString;
				String ip = documents.getString("IP");
				//TODO 健壮性
				double theLastOneNum = numMap.get(ip) == null ? 0d : numMap.get(ip) ;
				objects[1] = documents.getDouble("To_Num") - theLastOneNum;
				
				Object[] object2 = new Object[2];
				object2[0] = dateString;
				//TODO 健壮性
				double theLastOneFromNum = fromMap.get(ip) == null ? 0d : fromMap.get(ip) ;
				object2[1] = documents.getDouble("From_Num") - theLastOneFromNum;
				
				List<Object[]> list = reMap.get(ip);
				if(list == null) {
					list = new ArrayList();
					reMap.put(ip, list);
				}
				list.add(objects);
				
				List<Object[]> listFrom = refromMap.get(ip);
				if(listFrom == null) {
					listFrom = new ArrayList();
					refromMap.put(ip, listFrom);
				}
				listFrom.add(objects);
			}
		};
		coll.find(query).sort(sort).forEach(processBlock);
		
		JSONArray jsonArray = new JSONArray();
		//遍历Map
		for (String key : reMap.keySet()) {  
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("name", key + "(IN)");
			jsonObject.put("data", reMap.get(key).toArray());
			jsonArray.add(jsonObject);
		}  
		
		for (String key : refromMap.keySet()) {  
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("name", key + "(OUT)");
			jsonObject.put("data", refromMap.get(key).toArray());
			jsonArray.add(jsonObject);
		}
		return jsonArray;
	}

	@Override
	public JSONArray packageIPBytes(String date) {
		MongoCollection<Document> coll = MongoDBUtils.instance.getCollection(dbName, collName);
		Document query = new Document();
		query.append("CulTime.TimeStamp",
				new Document().append("$gte", date + " 00:00:00").append("$lte", date + " 23:59:59"));
		Document sort = new Document();
		sort.append("CulTime.TimeStamp", 1.0);

		Map<String, List<Object[]>> reMap = new HashedMap();
		Map<String, List<Object[]>> refromMap = new HashedMap();
		
		Block<Document> processBlock = document -> {
			
			Document culTime = (Document) document.get("CulTime");
			//获取时间
			String dateString = culTime.get("TimeStamp").toString();
			
			//上一条数据
			Map<String,Double> numMap = getMap(coll,dateString,"From_Bytes");
			Map<String,Double> fromMap = getMap(coll,dateString,"To_Bytes");
			
			Document intraNet = (Document) document.get("IntraNet");
			//全部数据
			List<Document> lists = intraNet.get("Packet",new ArrayList());
			
			for(Document documents : lists) {
				
				Object[] objects = new Object[2];
				objects[0] = dateString;
				String ip = documents.getString("IP");
				//TODO 健壮性
				double theLastOneNum = numMap.get(ip) == null ? 0d : numMap.get(ip) ;
				objects[1] = documents.getDouble("From_Bytes") - theLastOneNum;
				
				Object[] object2 = new Object[2];
				object2[0] = dateString;
				//TODO 健壮性
				double theLastOneFromNum = fromMap.get(ip) == null ? 0d : fromMap.get(ip) ;
				object2[1] = documents.getDouble("To_Bytes") - theLastOneFromNum;
				
				List<Object[]> list = reMap.get(ip);
				if(list == null) {
					list = new ArrayList();
					reMap.put(ip, list);
				}
				list.add(objects);
				
				List<Object[]> listFrom = refromMap.get(ip);
				if(listFrom == null) {
					listFrom = new ArrayList();
					refromMap.put(ip, listFrom);
				}
				listFrom.add(objects);
			}
		};
		coll.find(query).sort(sort).forEach(processBlock);
		
		JSONArray jsonArray = new JSONArray();
		//遍历Map
		for (String key : reMap.keySet()) {  
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("name", key + "(IN)");
			jsonObject.put("data", reMap.get(key).toArray());
			jsonArray.add(jsonObject);
		}  
		
		for (String key : refromMap.keySet()) {  
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("name", key + "(OUT)");
			jsonObject.put("data", refromMap.get(key).toArray());
			jsonArray.add(jsonObject);
		}
		return jsonArray;
	}

	private Map<String, Double> getMap(MongoCollection<Document> coll, String date, String documentKey) {
		Document query = new Document();
		query.append("CulTime.TimeStamp", new Document().append("$lt", date));

		Document sort = new Document();
		sort.append("_id", -1.0);

		int limit = 1;

		Map<String, Double> map = new HashedMap();

		Block<Document> processBlock = new Block<Document>() {
			@Override
			public void apply(final Document document) {
				Document intraNet = (Document) document.get("IntraNet");
				// 全部数据
				List<Document> lists = intraNet.get("Packet", new ArrayList());
				for (Document documents : lists) {
					map.put(documents.getString("IP"), documents.getDouble(documentKey));
				}
			}
		};

		coll.find(query).sort(sort).limit(limit).forEach(processBlock);

		return map;
	}

}
