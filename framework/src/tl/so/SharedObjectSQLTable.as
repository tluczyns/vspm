package tl.so {
	import tl.sql.SQLTable;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	import flash.data.SQLResult;
	import flash.utils.getDefinitionByName;
	import flash.net.registerClassAlias;
	
	public class SharedObjectSQLTable implements ISharedObject {
		
		private var sqlTableSO: SQLTable;
		private var nameSO: String;
		
		public function SharedObjectSQLTable(nameSO: String, nameDirSO: String = ""): void {
			this.nameSO = nameSO;
			var dirSO: File;
			if (Capabilities.os.indexOf("Windows") != -1) dirSO = File.documentsDirectory;
			else dirSO = File.applicationStorageDirectory;
			if (nameDirSO) dirSO = dirSO.resolvePath(nameDirSO);
			this.sqlTableSO = new SQLTable(dirSO, nameSO, Object, ["name", "value", "nameClassValue"], ["TEXT", "BLOB", "TEXT"], [], false);
		}
		
		public function setPropValue(nameProp: String, valueProp: *): Boolean {
			//trace("setPropValue:", nameProp, valueProp)
			var baValueProp: ByteArray = new ByteArray();
			baValueProp.writeObject(valueProp);
			var nameClassValueProp: String = getQualifiedClassName(valueProp);
			var result: Boolean;
			if (this.sqlTableSO) {
				var parametersSQL: Array = [["name", nameProp], ["value", baValueProp], ["nameClassValue", nameClassValueProp]];
				this.sqlTableSO.sqlStm.executeSQL("UPDATE '" + this.nameSO + "' SET value = :value, nameClassValue = :nameClassValue WHERE name = :name;", parametersSQL);
				var sqlResult: SQLResult = this.sqlTableSO.sqlStm.getResult();
				//trace("sqlResult:", sqlResult.rowsAffected, sqlResult.data)
				if (sqlResult.rowsAffected == 0)
					this.sqlTableSO.sqlStm.executeSQL("INSERT INTO '" + this.nameSO + "' ('name', 'value', 'nameClassValue') VALUES (:name, :value, :nameClassValue);", parametersSQL);
				result = true;
			} else result = false;
			baValueProp.clear();
			baValueProp = null;
			return result;
		}
		
		public function getPropValue(nameProp: String, defaultValueProp: * = undefined): * {
			if (this.sqlTableSO) { 
				this.sqlTableSO.executeSQL("SELECT value, nameClassValue FROM '" + this.nameSO + "' WHERE name = '" + nameProp + "';");
				var sqlResult: SQLResult = this.sqlTableSO.sqlStm.getResult();
				var dataSQLResult: Array = sqlResult.data;
				if (dataSQLResult == null) dataSQLResult = [{value: defaultValueProp, nameClassValue: "Object"}];
				var result: Object = dataSQLResult[0];
				if (result.value) {
					var nameClassValueProp: String = String(result.nameClassValue);
					var classValueProp: Class = Class(getDefinitionByName(nameClassValueProp))
					registerClassAlias(nameClassValueProp, classValueProp);
					var baValueProp: ByteArray = ByteArray(result.value);
					var valueProp: * = baValueProp.readObject();
					baValueProp.clear();
					baValueProp = null;
				} else valueProp = defaultValueProp;
			} else valueProp = defaultValueProp;
			//trace("getPropValue:", nameProp, valueProp, classValueProp)
			return valueProp;
		}
		
		public function destroy(): void {
			this.sqlTableSO.destroy();
			this.sqlTableSO = null;
		}
		
	}

}