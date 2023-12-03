using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CutOffColor : MonoBehaviour {

    const string SHADER_NAME = "Hidden/CutOffColor";

    public Texture maskTexture;

    public Color opaqueColor = Color.red;           // 不透明部分の色
    public Color transparentColor = Color.black;    // 透明部分の色

    public bool isReverse = false;                  // 色反転フラグ

    public Vector2 maskPostion;
    public Vector2 maskVelocity;

    [SerializeField, HideInInspector]
    private Shader m_Shader;

    public Shader shader
    {
        get
        {
            if (m_Shader == null)
            {
                m_Shader = Shader.Find(SHADER_NAME);
            }

            return m_Shader;
        }
    }

    private Material m_Material;
    public Material material
    {
        get
        {
            if (m_Material == null)
                m_Material = new Material(shader);

            return m_Material;
        }
    }

    //private void OnDisable()
    //{
    //    if (m_Material != null)
    //        DestroyImmediate(m_Material);

    //    m_Material = null;
    //}

    int m_PID_MaskTexture = 0;
    int m_PID_OpaqueColor = 0;
    int m_PID_TransparentColor = 0;
    int m_PID_IsReverse = 0;
    int m_PID_MaskPosition = 0;
    //int m_PID_MaskVelocity = 0;

    private void Awake()
    {
        m_PID_MaskTexture = Shader.PropertyToID("_MaskTex");
        m_PID_OpaqueColor = Shader.PropertyToID("_OpaqueColor");
        m_PID_TransparentColor = Shader.PropertyToID("_TransparentColor");
        m_PID_IsReverse = Shader.PropertyToID("_IsReverse");
        m_PID_MaskPosition = Shader.PropertyToID("_MaskPosition");
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        material.SetTexture(m_PID_MaskTexture, maskTexture);
        material.SetColor(m_PID_OpaqueColor, opaqueColor);
        material.SetColor(m_PID_TransparentColor, transparentColor);
        material.SetInt(m_PID_IsReverse, (isReverse ? 1 : 0));
        material.SetVector(m_PID_MaskPosition, maskPostion);
        Graphics.Blit(source, destination, material);
    }

    private void Update()
    {
        float dt = Time.deltaTime;
        maskPostion.x += maskVelocity.x * dt;
        maskPostion.y += maskVelocity.y * dt;
    }

    public void ResetPosition()
    {
        maskPostion = Vector2.zero;
    }

    public void SetPosition(Vector2 pos)
    {
        maskPostion = pos;
    }

    public void SetVelocity(Vector2 velocity)
    {
        maskVelocity = velocity;
    }

    public void FlipReverse()
    {
        isReverse = !isReverse;
    }
}
