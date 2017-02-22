using System.Collections;
using UnityEngine;
using Tango;
using System;

public class AreaLearningStartup_v1 : MonoBehaviour, ITangoLifecycle, ITangoEvent
{
    [SerializeField]
    UnityEngine.UI.Text m_savingText;

    private TangoApplication m_tangoApplication;
    //TangoApplication: Register (to get callbacks) -> RequestPermissions -> Startup

    public void Start()
    {
        m_tangoApplication = FindObjectOfType<TangoApplication>();
        if(m_tangoApplication != null)
        {
            m_tangoApplication.Register(this);
            m_tangoApplication.RequestPermissions();
        }
    }

    public void OnTangoPermissions(bool permissionsGranted)
    {
        if(permissionsGranted)
        {
            AreaDescription[] list = AreaDescription.GetList();
            AreaDescription mostRecent = null;
            AreaDescription.Metadata mostRecentMetaData = null;
            if(list.Length > 0)
            {
                //Find and load the most recent Area Description
                mostRecent = list[0];
                mostRecentMetaData = list[0].GetMetadata();
                foreach(AreaDescription areaDescription in list)
                {
                    AreaDescription.Metadata metadata = areaDescription.GetMetadata();
                    if(metadata.m_dateTime > mostRecentMetaData.m_dateTime)
                    {
                        mostRecent = areaDescription;
                        mostRecentMetaData = metadata;
                    }
                }
                m_tangoApplication.Startup(mostRecent);
            }
            else
            {
                m_tangoApplication.Startup(null);
            }
        }
    }

    public void OnTangoServiceConnected()
    {
    }

    public void OnTangoServiceDisconnected()
    {
    }

    public void OnTangoEventAvailableEventHandler(TangoEvent tangoEvent)
    {
        if(tangoEvent.type == TangoEnums.TangoEventType.TANGO_EVENT_AREA_LEARNING && tangoEvent.event_key == "AreaDescriptionSaveProgress")
        m_savingText.text = "Saving. " + (float.Parse(tangoEvent.event_value) * 100) + "%";
    }
}
