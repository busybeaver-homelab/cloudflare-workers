import { type BasicAuthResult, parse } from 'basic-auth';

interface Env {
  KV: KVNamespace;
}

const validateAuth = (credentials: BasicAuthResult | undefined): boolean => {
};

export const onRequest: PagesFunction<Env> = async (context) => {
  try {
    const credentials = parse(context.request.headers.get('Proxy-Authorization'));

    if (validateAuth(credentials)) {
      return await context.next();
    }

    // auth failed or missing
    return new Response('Access denied', { status: 401, headers: { 'WWW-Authenticate': 'Basic charset="UTF-8"' } });
  } catch (err) {
    return new Response(`${err.message}\n${err.stack}`, { status: 500 });
  }
};
