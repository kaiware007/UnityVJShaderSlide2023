using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class RGBShiftGlitch : MonoBehaviour
{
    const string SHADER_NAME = "Hidden/RGBShiftGlitch";

    /// <summary>
    /// ずらす幅(解像度に比例)
    /// </summary>
    [Range(0, 1)]
    public float shiftPower = 1;

    /// <summary>
    /// ずらす方向のノイズ速度
    /// </summary>
    [Range(0,10)]
    public float noiseSpeed = 1;

    /// <summary>
    /// ノイズスケール
    /// </summary>
    public float noiseScale = 100;

    [SerializeField]
    AnimationCurve curve = AnimationCurve.Constant(0, 1, 1);
    [SerializeField]
    float maxPower = 1;

    [SerializeField]
    float time = 1;
    float duration = 0;

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

    // PropertyID
    int m_PID_shiftPower = 1;
    int m_PID_noiseSpeed = 1;
    int m_PID_noiseScale = 1;

    private void Awake()
    {
        m_PID_shiftPower = Shader.PropertyToID("_RGBShiftPower");
        m_PID_noiseSpeed = Shader.PropertyToID("_RGBNoiseSpeed");
        m_PID_noiseScale = Shader.PropertyToID("_RGBNoiseScale");
        // Debug.Log("m_PID_shiftPower " + m_PID_shiftPower + " m_PID_noiseSpeed " + m_PID_noiseSpeed + " m_PID_noiseScale " + m_PID_noiseScale);
    }


    private void Start()
    {
        material.SetFloat(m_PID_shiftPower, 0);
    }

    private void Update()
    {
        if (duration > 0)
        {
            duration -= Time.deltaTime;

            float t = Mathf.Clamp01(1f - duration / time);
            shiftPower = curve.Evaluate(t) * maxPower;

            //material.SetFloat(m_PID_shiftPower, p);
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        material.SetFloat(m_PID_shiftPower, shiftPower);
        material.SetFloat(m_PID_noiseSpeed, noiseSpeed);
        material.SetFloat(m_PID_noiseScale, noiseScale);
        Graphics.Blit(source, destination, material);
    }

    public void Beat()
    {
        if (!enabled)
            return;

        duration = time;
    }
}
