Shader "Shader_De_Prueba" {
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
		int _pos;
	};

	sampler2D _MainTex;
	sampler2D _BumpMap;
	float _metros_x;
	float _metros_y;
	
	void surf(Input IN, inout SurfaceOutput o) 
	{
		_metros_x = max(_metros_x, 0.5 ); 
		_metros_y = max(_metros_y, 0.5 ); 

		float comp_x_norm_wrold = IN.worldPos[0];
		float comp_y_norm_wrold = IN.worldPos[1];
		float mult_x = comp_x_norm_wrold/_metros_x;
		float mult_y = comp_y_norm_wrold/_metros_y;

		if( comp_x_norm_wrold > _metros_x  )
		{
			comp_x_norm_wrold = comp_x_norm_wrold - _metros_x * floor(mult_x);
		}
		else if( comp_x_norm_wrold < 0.0 )
		{
			comp_x_norm_wrold = comp_x_norm_wrold + _metros_x * (floor(mult_x) + 1);
		}

		if( comp_y_norm_wrold > _metros_y )
		{
			comp_y_norm_wrold = comp_y_norm_wrold - _metros_y * floor(mult_y);
		}
		else if( comp_y_norm_wrold < 0.0 )
		{
			comp_y_norm_wrold = comp_y_norm_wrold + _metros_y * (floor(mult_y) + 1);
		}

		comp_y_norm_wrold = comp_y_norm_wrold /_metros_y ;
		comp_x_norm_wrold = comp_x_norm_wrold / _metros_x ;

		
//		o.Albedo = float3(comp_x_norm_wrold ,comp_y_norm_wrold, 0.0);
		o.Albedo = tex2D(_MainTex, float2(comp_x_norm_wrold,comp_y_norm_wrold) ).rgb;
		o.Normal = UnpackNormal(tex2D(_BumpMap, float2(comp_x_norm_wrold,comp_y_norm_wrold))); 
//		o.Albedo = tex2D(_MainTex, IN.uv_MainTex ).rgb;
//		o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex ));
	}
	ENDCG
	}
		Fallback "Diffuse"
}

