using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class FoldRotate : MonoBehaviour
{
    const string SHADER_NAME = "Hidden/FoldRotate";

    public float divNum = 3;
    public float rotateSpeed = 0.5f;

    float rotateTime = 0;

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

    // PropertyID
    int m_PID_divNum = 1;
    int m_PID_rotateTime = 1;
    int m_PID_uvScale = 1;

    public void SetDivNum(float num)
    {
        divNum = num;
    }

    public void SetRotateSpeed(float speed)
    {
        rotateSpeed = speed;
    }

    // Start is called before the first frame update
    void Awake()
    {
        m_PID_divNum = Shader.PropertyToID("_DivNum");
        m_PID_rotateTime = Shader.PropertyToID("_RotateTime");
        m_PID_uvScale = Shader.PropertyToID("_UVScale");
    }

    private void Update()
    {
        rotateTime += Time.deltaTime * rotateSpeed;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {

        //float outputAspect = (float)destination.height / (float)destination.width;
        // Vector2 uvScale = TextureBlend.CalcUVScale(destination.width, destination.height, source.width, source.height);

        material.SetFloat(m_PID_divNum, divNum);
        material.SetFloat(m_PID_rotateTime, rotateTime);
        // material.SetVector(m_PID_uvScale, uvScale);

        Graphics.Blit(source, destination, material);
    }
}
