// by ficool2

if (!("KV_Indents" in getroottable()))
{	
	// const strings are faster than literal strings
	const KV_INTEGER = "integer";
	const KV_FLOAT = "float";
	const KV_STRING = "string";
	const KV_BOOL = "bool";
	const KV_VECTOR = "Vector";
	const KV_QANGLE = "QAngle";

	const KV_BLANK = "";
	const KV_TAB = "\t";
	const KV_DOUBLEQUOTE = "\"";
	// valve writes \t\t instead of one space
	const KV_SEPARATOR = "\" \"";
	const KV_DOUBLEQUOTEN = "\"\n";
	const KV_OPENBRACEN = "{\n";
	const KV_CLOSEBRACEN = "}\n";
	
	::KV_Indents <- [];

	local indent = KV_BLANK;
	for (local i = 0; i < 64; i++)
	{
		KV_Indents.append(indent);
		indent += KV_TAB;
	}
}

::KeyValues <- class
{
	function constructor(name, parent = null)
	{
		m_Name = name;
		if (parent)
			parent.AddSubKey(this);
	}
	
	function FindKey(key, create = false)
	{
		local dat;
		local last_dat = null;
		
		for (dat = m_Sub; dat; dat = dat.m_Peer)
		{
			last_dat = dat;
			if (dat.m_Name == key)
				break;
		}
		
		if (!dat)
		{
			if (create)
			{
				dat = KeyValues(key);
				
				if (last_dat)
					last_dat.m_Peer = dat;
				else
					m_Sub = dat;
			}
		}
			
		return dat;
	}
	
	function AddSubKey(subkey)
	{
		if (!m_Sub)
		{
			m_Sub = subkey;
		}
		else
		{
			local dat = m_Sub;
			while (dat.m_Peer)
				dat = dat.m_Peer;
			dat.m_Peer = subkey;
		}
	}
	
	function Set(key, value)
	{
		local dat = FindKey(key, true);	
		switch (typeof(value))
		{
			case KV_VECTOR:
				dat.m_Value = value + Vector();
				break;
			case KV_QANGLE:
				dat.m_Value = value + QAngle();
				break;
			default:
				dat.m_Value = value;
				break;
		}
	}
	
	function SetInt(key, value)
	{
		local dat = FindKey(key, true);	
		if (typeof(value) == KV_INTEGER)
			dat.m_Value = value;
		else
			dat.m_Value = value.tointeger();
	}
	
	function SetFloat(key, value)
	{
		local dat = FindKey(key, true);	
		if (typeof(value) == KV_FLOAT)
			dat.m_Value = value;
		else
			dat.m_Value = value.tofloat();	
	}
	
	function SetString(key, value)
	{
		local dat = FindKey(key, true);	
		if (typeof(value) == KV_STRING)
			dat.m_Value = value;
		else
			dat.m_Value = value.tostring();	
	}
	
	function SetBool(key, value)
	{
		local dat = FindKey(key, true);	
		if (typeof(value) == KV_BOOL)
			dat.m_Value = value.tointeger();
		else
			dat.m_Value = !!value.tointeger();
	}
	
	function SetVector(key, value)
	{
		local dat = FindKey(key, true);	
		dat.m_Value = value + Vector();
	}
	
	function SetQAngle(key, value)
	{
		local dat = FindKey(key, true);	
		dat.m_Value = value + QAngle();
	}
	
	function SaveToFile(rootless = false)
	{
		local buf;
		if (rootless)
		{
			buf = KV_BLANK;
			for (local dat = m_Sub; dat; dat = dat.m_Peer)
				buf = dat.SaveKeyToFile(buf, -1);
		}
		else
		{
			buf = RecursiveSaveToFile(KV_BLANK, 0);
		}
		
		StringToFile(m_Name, buf);
		return true;
	}
	
	function LoadFromFile()
	{
		local buf = FileToString(m_Name);
		if (!buf)
			return false;
		
		printl("KeyValues LoadFromFile is not implemented!");
		return true;
	}
	
	function SaveKeyToFile(buf, indent_level)
	{
		if (m_Sub)
		{
			return RecursiveSaveToFile(buf, indent_level + 1);
		}
		else
		{
			buf += KV_Indents[indent_level + 1];
			buf += KV_DOUBLEQUOTE;
			buf += m_Name;
			buf += KV_SEPARATOR;
			
			switch (typeof(m_Value))
			{
				case KV_VECTOR:
				case KV_QANGLE:
					buf += format("%f %f %f", m_Value.x, m_Value.y, m_Value.z);
					break;
				default:
					buf += m_Value;
					break;
			}
				
			buf += KV_DOUBLEQUOTEN;
		}
		return buf;
	}
	
	function RecursiveSaveToFile(buf, indent_level)
	{
		buf += KV_Indents[indent_level];
		buf += KV_DOUBLEQUOTE;
		buf += m_Name;
		buf += KV_DOUBLEQUOTEN;
		buf += KV_Indents[indent_level];
		buf += KV_OPENBRACEN;
		
		for (local dat = m_Sub; dat; dat = dat.m_Peer)
			buf = dat.SaveKeyToFile(buf, indent_level);
			
		buf += KV_Indents[indent_level];
		buf += KV_CLOSEBRACEN;
		return buf;
	}
	
	m_Name = null;
	m_Value = null;
	
	m_Sub = null;
	m_Peer = null;
}