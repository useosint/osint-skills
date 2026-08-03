export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    if (url.pathname === "/catalog.json" || url.pathname === "/catalog.json/") {
      const obj = await env.ASSETS.fetch(new Request(new URL("/catalog.json", url.origin)));
      const headers = new Headers(obj.headers);
      headers.set("Access-Control-Allow-Origin", "*");
      headers.set("Cache-Control", "public, max-age=60, s-maxage=300");
      headers.set("Content-Type", "application/json; charset=utf-8");
      return new Response(obj.body, { status: obj.status, headers });
    }
    return env.ASSETS.fetch(request);
  },
};
