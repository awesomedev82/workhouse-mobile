
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'
import { JWT } from 'npm:google-auth-library@9'

interface Announcement {
  id: any
  created_at: any
  sender: any
  description: any
  images: any
  community_id: any
  hide: any
}

interface WebhookPayload {
  type: 'INSERT'
  table: string
  record: Announcement
  schema: 'public'
  old_record: null | Announcement
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  const payload: WebhookPayload = await req.json();

  const { data } = await supabase.from('member_fcm_tokens').select('token').eq('id', payload.record.sender).single();

  const fcmToken = data!.token as string;

  const { default: serviceAccount } = await import('../service-account.json', {
    with: { type: 'json' },
  })

  const accessToken = await getAccessToken({ clientEmail: serviceAccount.client_email, privateKey: serviceAccount.private_key, });

  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${project_id}/messages:send`,
    {
      method: 'POST',
      headers: {
        'Content-Type': 'applicatioin/json',
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({
        token: fcmToken,
        notification: {
          title: 'New announcement',
          body: 'New announcement was posted recently!',
        }
      })
    }
  )

  cosnt resData = await res.json();
  if (res.status < 200 || 299 < res.status) {
    throw resData;
  }

  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  )
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    jwtClient.authorize((err, tokens) => {
      if (err) {
        reject(err)
        return;
      }
      resolve(tokens!.access_token!)
    })
  })
}