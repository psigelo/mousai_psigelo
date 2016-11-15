Shader "Cube world coords with diffuse and normals" {
	Properties{
		_MainTex("Textura", 2D) = "white" {}
		_BumpMap("Mapa de normales", 2D) = "bump" {}
		_metros_x("Metros imagen se repite (EJE X)", Float) = 1
		_metros_y("Metros imagen se repite (EJE Y)", Float) = 1
	}
		SubShader{
		Tags{ "RenderType" = "Opaque" }
		CGPROGRAM
#include "UnityCG.cginc"
#pragma surface surf Lambert

	struct Input {
		float2 uv_MainTex;
		float2 uv_BumpMap;
		float3 worldPos;
		float3 worldNormal;
		int _pos;
	};

	sampler2D _MainTex;
	sampler2D _BumpMap;
	float _metros_x;
	float _metros_y;

	
	float2 transformToCorrectComponentsSizes ( float comp_u2, float comp_u3)
	{
		float mult_x = comp_u2/_metros_x;
		float mult_y = comp_u3/_metros_y; 

		if( comp_u2 > _metros_x  )
		{
			comp_u2 = comp_u2 - _metros_x * floor(mult_x);
		}
		else if( comp_u2 < 0.0 )
		{
			comp_u2 = comp_u2 + _metros_x * (floor(mult_x) + 1);
		}

		if( comp_u3 > _metros_y )
		{
			comp_u3 = comp_u3 - _metros_y * floor(mult_y);
		}
		else if( comp_u3 < 0.0 )
		{
			comp_u3 = comp_u3 + _metros_y * (floor(mult_y) + 1);
		}

		comp_u2 = comp_u2 / _metros_x ;
		comp_u3 = comp_u3 /_metros_y ;
		return float2(comp_u2,comp_u3);
	}

	void surf(Input IN, inout SurfaceOutput o) 
	{
		_metros_x = max(_metros_x, 0.5 ); 
		_metros_y = max(_metros_y, 0.5 );
		// Hay 6 caras.

		o.Albedo = half3(0.3,0.1,0.2);
		if( IN.worldNormal[0] == 1.0 && IN.worldNormal[1] == 0.0 && IN.worldNormal[2] == 0.0  ) // Cara uno
		{
			// Obteniendo la base completa de vectoresortonormales (u1,u2,u3) ver grand-smith process para entender mejor
			// donde u1 es el vector normal.
			half3 u2 = half3(0.0,1.0,0.0);
			half3 u3 = half3(0.0,0.0,1.0);
			// 
			float comp_u2 = dot(IN.worldPos, u2);
			float comp_u3 = dot(IN.worldPos, u3);

			float2 correct_components = transformToCorrectComponentsSizes(comp_u2,comp_u3);

			o.Albedo = tex2D(_MainTex, correct_components).rgb;

		}
		else if( IN.worldNormal[0] == 0.0 && IN.worldNormal[1] == 1.0 && IN.worldNormal[2] == 0.0  ) // Cara 2
		{
			o.Albedo = half3(0.0,1.0,0.0);
		}
		else if( IN.worldNormal[0] == 0.0 && IN.worldNormal[1] == 0.0 && IN.worldNormal[2] == 1.0  ) // Cara 3
		{
			o.Albedo = half3(0.0,0.0,1.0);
		}
		else if( IN.worldNormal[0] == -1.0 && IN.worldNormal[1] == 0.0 && IN.worldNormal[2] == 0.0  ) // Cara 4
		{
			o.Albedo = half3(1.0,0.0,0.0);
		}
		else if( IN.worldNormal[0] == 0.0 && IN.worldNormal[1] == -1.0 && IN.worldNormal[2] == 0.0  ) // Cara 5
		{
			o.Albedo = half3(0.0,1.0,0.0);
		}
		else if( IN.worldNormal[0] == 0.0 && IN.worldNormal[1] == 0.0 && IN.worldNormal[2] == -1.0  ) // Cara 6
		{
			o.Albedo = half3(0.0,0.0,1.0);
		}


		//o.Normal = UnpackNormal(tex2D(_BumpMap, float2(comp_x_norm_wrold,comp_y_norm_wrold))); 
	}
	ENDCG
	}
		Fallback "Diffuse"
}

