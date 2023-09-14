# VScript KeyValues
Barebones standalone library that allows writing of Valve's KeyValues format. 

Useful for writing out formatted files such as vmf, cfg, vdf, txt...

# Usage
Include the `keyvalues.nut` script, i.e. `IncludeScript("keyvalues")`. 

Initialize a KeyValues class with a name, e.g. `local kv = KeyValues("my_keyvalues.txt")`;

Key/value pairs can be added or modified using the generic `Set` function, or the type-specific `Set<type>` functions that perform conversions where available, e.g. `SetFloat`.

The `FindKey` function can be used to find an existing key, returning null if it does not exist.

Sub-keyvalues can be added by creating a new KeyValues class, then specifying the parent keyvalue as the 2nd argument in the constructor. Alternatively, `AddSubKey` can be called on the parent keyvalue.

The keyvalues can be written to disk using `SaveToFile`. These will be written to the game's `scriptdata` folder. 

`SaveToFile` has an optional boolean `rootless` parameter (false by default). If true, the top root key won't be written, which matches the syntax of certain file formats such as VMF.

Iterating keys can be done using the following loop:	
```js
for (local dat = kv.m_Sub; dat; dat = dat.m_Peer)
```

# Example
```js
IncludeScript("keyvalues");

local kv = KeyValues("kv_test.cfg");
kv.Set("foo", 32);
kv.Set("bar", 621.69);

local subkv = KeyValues("test", kv);
subkv.Set("hello", true);
subkv.Set("world", "is dead");

kv.SaveToFile();
```

Which produces the following file named `kv_test.cfg`:
```
"kv_test.cfg"
{
	"foo" "32"
	"bar" "621.69"
	"test"
	{
		"hello" "1"
		"world" "is dead"
	}
}
```

# Limitations
Reading support is not implemented yet.

The performance is slow, do not use this for any runtime work as it is very expensive.

No support for removing keys, though it should be simple to add.

# License
Do whatever the hell you want
