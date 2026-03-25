class SlingResource {
    constructor(url) {
        this.baseUrl = url;
    }

    async getProperty(path,prop) {
        var reqUrl = `${this.baseUrl}${path}`
        var req = new WebRequest('GET',reqUrl);
        return await req.response.then(resp => {
            var ob = JSON.parse(resp.body);
            return ob[prop];
        });
    }

    async setProperty(path,prop,value) {
        var reqUrl = `${this.baseUrl}${path}`

        var thisFormData = new FormData();
        thisFormData.append(prop,value);

        var req = new WebRequest('POST',reqUrl,{
            data : thisFormData
        });

        return await req.response.then(resp => {
            return (resp.status == 200);
        });
    }

    async createCollection(path) {
        var reqUrl = `${this.baseUrl}${path}`;
        
        var req = new WebRequest('MKCOL',reqUrl);
        
        return await req.response.then(resp => {
            return (resp.status == 201);
        });
    }
}
